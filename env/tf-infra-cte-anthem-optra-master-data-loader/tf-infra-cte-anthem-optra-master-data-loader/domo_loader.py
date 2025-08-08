import os
import requests
import time
import logging
import psycopg2
from requests.auth import HTTPBasicAuth
from datetime import date

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# --- Environment Variables ---
DOMO_CLIENT_ID = os.getenv('DOMO_CLIENT_ID')
DOMO_CLIENT_SECRET = os.getenv('DOMO_CLIENT_SECRET')
DOMO_DATASET_ID = os.getenv('DOMO_DATASET_ID')
CLOUD_SQL_INSTANCE = os.getenv('CLOUD_SQL_INSTANCE') 
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('DB_USER')  

DOMO_API_URL_TEMPLATE = f"https://api.domo.com/v1/datasets/{DOMO_DATASET_ID}/data?includeHeader=true&fileName=Q4_Sales_Data.csv"
LOCAL_CSV_TEMPLATE = '/tmp/master_dataset_{date}.csv'

# --- Helper Functions ---
def get_access_token(client_id, client_secret, scopes):
    token_url = 'https://api.domo.com/oauth/token'
    payload = {'grant_type': 'client_credentials', 'scope': scopes}
    response = requests.post(token_url, auth=HTTPBasicAuth(client_id, client_secret), data=payload)
    response.raise_for_status()
    return response.json().get('access_token')

def download_dataset_to_local(api_url, headers, local_path):
    for attempt in range(3):
        try:
            logging.info(f"[DOMO] Download attempt {attempt + 1}")
            response = requests.get(api_url, headers=headers, timeout=30)
            response.raise_for_status()

            with open(local_path, 'wb') as f:
                f.write(response.content)

            logging.info(f"[DOMO] Dataset downloaded to {local_path}")
            return
        except Exception as e:
            logging.warning(f"[DOMO] Attempt {attempt + 1} failed: {e}")
            time.sleep(2 ** attempt)
    raise Exception("Failed to download dataset from DOMO after 3 attempts.")

def get_db_connection():
    return psycopg2.connect(
        user=DB_USER,
        dbname=DB_NAME,
        host='127.0.0.1',
        password=os.environ.get("PGPASSWORD"),  
        port=5432
    )

def insert_data_from_csv_to_stage_table():
    today_str = date.today().strftime("%Y-%m-%d")
    csv_path = LOCAL_CSV_TEMPLATE.format(date=today_str)
    if not os.path.exists(csv_path):
        raise FileNotFoundError(f"CSV file not found: {csv_path}")
    
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute('TRUNCATE TABLE "OPTRA".stage_domo_api_tbl;')
    connection.commit()

    with open(csv_path, 'r') as f:
        cursor.copy_expert(
            sql=""" 
            COPY "OPTRA".stage_domo_api_tbl (
                province, coidpr, co_name, fmsid, building_id, lpds_id, circuit,
                penny_planning_stream, proposed_migration_stream, bu_claimed_res,
                bu_claimed_biz, bu_claimed_wh, migration_stream_flag_discrepency,
                confirmed_stream, sub_stream, service_type, service_class,
                svp_status_code, cable_status_code, use_code, full_line_equipment,
                switch_clli_code, switch_clli_code_db2, dsl_serving_dslam,
                cable_id, pair, terminal_no, terminal_type_code, premise_type,
                fsa, address_data, apartment_no, house_no, street_name, city,
                first_nation, qualification_results, addr_state, nap_details,
                exists_in_ppc, encepta_notes, drop_needed, drop_status,
                drop_close_date, drop_cancelled_reason,
                drop_cancelled_reason_description, build_scope, jira_key,
                roe_project_name, building_prems_mxu_only, roe_status,
                jira_comments, build_status, ifc_pre_build_pkg_forecast,
                ifc_build_in_progress_actual, rtb_quote_complete,
                build_in_progress, forecast_rfs_tested_date, actual_rfs_date,
                build_partner, migration_cohort, migration_status,
                migration_sub_status, attempt_migration_date,
                migration_complete_date, re_exit_strategy, residential_cust_id,
                overall_status, penny_in_funnel_year, current_status_prime,
                penny_community_pm, appian_landing_page_co_group, exception_data,
                status_exception, approval_status_exception, exception_reason,
                coid, isw_status, current_status,
                min_fibre_requirements, build_stream, community_decom_date,
                forecast_build_start_date, udpu_flag, obd_flag,
                migration_cohort_start_date, site_filter, gpon_qualification_ind,
                building_type, jira_status, t1_nap_capacity, t1_fdh_capacity,
                t1_co_capacity, t1_fibre_facility_check, unique_id_key,
                update_date, clli 
            )
            FROM STDIN WITH CSV HEADER
            """,
            file=f
        )

    connection.commit()
    cursor.close()
    connection.close()
    logging.info("CSV data inserted into 'stage_domo_api_tbl' successfully.")

def update_audit_log():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.callproc('"OPTRA".update_insert_audit_log_procedure_with_first_time')
    connection.commit()
    cursor.close()
    connection.close()
    logging.info("Audit log updated successfully.")

def update_prod_table():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.callproc('"OPTRA".update_prod_table_stage_tbl')
    connection.commit()
    cursor.close()
    connection.close()
    logging.info("Production table updated successfully.")

def update_appain_circuit_status():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.callproc('"OPTRA".update_appain_circuit_status_batch')
    connection.commit()
    cursor.close()
    connection.close()
    logging.info("Appain circuit status updated.")

def update_svp_status():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.callproc('"OPTRA".update_svp_status_in_prod_domo_and_audit_logs')
    connection.commit()
    cursor.close()
    connection.close()
    logging.info("SVP status updated.")

# --- Main Request Handler ---
def main_fn(request):
    try:
        # Check environment variables
        required_vars = {
            "DOMO_CLIENT_ID": DOMO_CLIENT_ID,
            "DOMO_CLIENT_SECRET": DOMO_CLIENT_SECRET,
            "DOMO_DATASET_ID": DOMO_DATASET_ID,
            "DB_USER": DB_USER,
            "DB_NAME": DB_NAME
        }
        missing = [k for k, v in required_vars.items() if not v]
        if missing:
            raise EnvironmentError(f"Missing environment variables: {', '.join(missing)}")

        today_str = date.today().strftime("%Y-%m-%d")
        csv_path = LOCAL_CSV_TEMPLATE.format(date=today_str)

        access_token = get_access_token(DOMO_CLIENT_ID, DOMO_CLIENT_SECRET, scopes='data')
        logging.info(f"[DOMO] Access token obtained.")

        headers = {
            'Authorization': f'Bearer {access_token}',
            'Content-Type': 'text/csv',
            'Accept': 'text/csv',
        }

        download_dataset_to_local(DOMO_API_URL_TEMPLATE, headers, csv_path)
        insert_data_from_csv_to_stage_table()
        update_audit_log()
        update_prod_table()
        update_appain_circuit_status()
        update_svp_status()

        return ("Success: Master dataset downloaded and DB updated", 200)

    except Exception as e:
        logging.error(f"Error in main_fn: {e}")
        return (f"Error: {str(e)}", 500)