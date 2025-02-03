// Configure the Google Cloud provider
provider "google" {
  #credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

provider "google-beta" {
  #credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone

}

module "vpc" {
  source = "./modules/vpc/"
  # ---------------------- web-dv-tac-common-vpc ----------------------
  network_name1   = "web-dv-tac-common-vpc"
  region          = "northamerica-northeast1"

  # ---------------------- web-dv-tac-frontend-subnet ----------------------
  subnet_name1    = "web-dv-tac-frontend-subnet"
  subnet_range1   = "10.163.148.0/27"
  private_access1 = "true"

 # ---------------------- web-dv-tac-frontend-ha-subnet ----------------------
  subnet_name2    = "web-dv-tac-frontend-ha-subnet"
  subnet_range2   = "10.163.148.32/27"
  private_access2 = "true"

 # ---------------------- web-dv-tac-backend-subnet ----------------------
  subnet_name3    = "web-dv-tac-backend-subnet"
  subnet_range3   = "10.163.148.64/27"
  private_access3 = "true"

 # ---------------------- web-dv-tac-backend-ha-subnet ----------------------
  subnet_name4    = "web-dv-tac-backend-ha-subnet"
  subnet_range4   = "10.163.148.96/27"
  private_access4 = "true"

 # ---------------------- web-dv-tac-common-subnet ----------------------
  subnet_name5    = "web-dv-tac-common-subnet"
  subnet_range5   = "10.163.148.128/27"
  private_access5 = "true"
 
}


# module "bucket" {
#    source = "./modules/bucket/"
#     #----------------web-dev-tac-tf-backend----------------------#
#     bucketname1     = "web-dev-tac-tf-backend"
#     location1       = "NAM4"
#     storage_class1  = "STANDARD"
#     #---------LABELS----------------#
#     name1        = "web-dev-tac-tf-backend"
#     project1     = "tac"  
#     role1        = "web-dev-tac-backend"        
#     owner1       = "devops"         
#     env1         = "web-dev-tac"      
#     terraform1   = "yes"

# }

# module "vm" {
#   source = "./modules/vm/"
  
#   # #-------------dvmon-------------------------#
#   # vm1                = "dvmon"
#   # machine_type1      = "e2-standard-2"
#   # vm_zone1           = "northamerica-northeast1-a"
#   # image1             = "projects/windows-cloud/global/images/windows-server-2022-dc-v20240711"
#   # size1              = "50"
#   # type1              = "pd-standard"
#   # ip_forwarding1     = "false"
#   # deletion_protection1 = "false"
#   # tags1              = ["rdp"]
#   # network1           = module.vpc.network_self_link
#   # subnet-1-name      = module.vpc.subnet-name5
#   # #---------- LABELS--------------------#
#   # project1     = "tac"
#   # role1        = "dvmon"
#   # env1         = "web-dev-tac"
#   # owner1       = "devops"
#   # terraform1   = "yes"
#   # name1        = "dvmon"
#   # schedule1    = "yes"

#   #---------------------dvjmp-------------------------------#
#   vm2                  = "dvjmp"
#   machine_type2        = "e2-standard-2"
#   vm_zone2             = "northamerica-northeast1-a"
#   image2               = "projects/windows-cloud/global/images/windows-server-2016-dc-v20240711"
#   size2                = "51"
#   type2                = "pd-standard"
#   ip_forwarding2       = "false"
#   deletion_protection2 = "true"
#   tags2                = ["rdp","dashboard"]
#   network2             = module.vpc.network_self_link
#   subnet-2-name        = module.vpc.subnet-name5
#   #-----------LABELS-----------#
#   project2    = "tac"
#   role2       = "dvjmp"
#   env2        = "web-dev-tac"
#   owner2      = "devops"
#   terraform2  = "yes"
#   name2       = "dvjmp"
#   schedule2   = "yes"

#   # #----------------dvsql------------------------------#
#   # vm3           = "dvsql"
#   # machine_type3 = "e2-standard-2"
#   # vm_zone3      = "northamerica-northeast1-a"
#   # image3        = "projects/windows-sql-cloud/global/images/sql-2017-standard-windows-2016-dc-v20240711"
#   # size3         = "50"
#   # type3         = "pd-standard"
#   # ip_forwarding3 = "false"
#   # deletion_protection3 = "false"
#   # tags3         = ["rdp"]
#   # network3      = module.vpc.network_self_link
#   # subnet-3-name = module.vpc.subnet-name5
#   # #-------- LABELS----------#
#   # project3    = "tac"
#   # role3       = "dvsql"
#   # env3        = "web-dev-tac"
#   # owner3      = "devops"
#   # terraform3  = "yes"
#   # name3       = "dvsql"
#   # schedule3   = "yes"

#   # ---------------------- dvgui01 ---------------------- #
#   vm4                  = "dvgui01"
#   machine_type4        = "n1-standard-1"
#   vm_zone4             = "northamerica-northeast1-a"
#   image4               = "ubuntu-os-cloud/ubuntu-2004-lts"
#   size4                = "20"
#   type4                = "pd-standard"
#   ip_forwarding4       = "false"
#   deletion_protection4 = "true"
#   tags4                = ["ssh","dashboard","hc"]
#   network4             = module.vpc.network_self_link
#   subnet-4-name        = module.vpc.subnet-name1
#   # ---------------------- LABELS ---------------------- #
#   project4    = "tac"
#   role4       = "dvgui01"
#   env4        = "web-dev-tac"
#   owner4      = "devops"
#   terraform4  = "yes"
#   name4       = "dvgui01"
#   schedule4   = "yes"

# #------------------------dvad-server-----------------------#
  
#   #-------------internalIP---------------#
#   internalip_name   = "tac-dev-ad-internal-ip"
#   subnetwork        = module.vpc.subnet-name5
#   ad_internal_ip    = "10.163.148.134"
#   internalip_region = "northamerica-northeast1"

#   vm5               = "dvad"
#   machine_type5     = "e2-medium"
#   vm_zone5          = "northamerica-northeast1-a"
#   image5            = "projects/windows-cloud/global/images/windows-server-2016-dc-v20240711"
#   size5             = "50"
#   type5             = "pd-standard"
#   ip_forwarding5    = "false"
#   deletion_protection5 = "true"
#   tags5             = ["rdp","ad"]
#   network5          = module.vpc.network_self_link
#   subnet-05-name    = module.vpc.subnet-name5

#   #--------- LABELS----------------#
#   project5          = "tac"
#   role5             = "dvad"
#   env5              = "web-dev-tac"
#   owner5            = "devops"
#   terraform5        = "yes"
#   name5             = "dvad"
#   schedule5         = "yes"

#   # ---------------------- dvapi01 ---------------------- #
#   vm6                  = "dvapi01"
#   machine_type6        = "n1-standard-1"
#   vm_zone6             = "northamerica-northeast1-a"
#   image6               = "ubuntu-os-cloud/ubuntu-2004-lts"
#   size6                = "20"
#   type6                = "pd-standard"
#   ip_forwarding6       = "false"
#   deletion_protection6 = "true"
#   tags6                = ["ssh","dashboard","hc"]
#   network6             = module.vpc.network_self_link
#   subnet-6-name        = module.vpc.subnet-name3
#   # ---------------------- LABELS ---------------------- #
#   project6             = "tac"
#   role6                = "dvapi01"
#   env6                 = "web-dev-tac"
#   owner6               = "devops"
#   terraform6           = "yes"
#   name6                = "dvapi01"
#   schedule6            = "yes"

#   # ---------------------- tactpm-tstgui01 ---------------------- #
#   vm7                  = "tactpm-tstgui01"
#   machine_type7        = "n1-standard-1"
#   vm_zone7             = "northamerica-northeast1-a"
#   image7               = "projects/web-dev-tac/global/images/tactpm-tstgui01-image-13-12-2024"
#   size7                = "20"
#   type7                = "pd-standard"
#   ip_forwarding7       = "false"
#   deletion_protection7 = "true"
#   tags7                = ["ssh","dashboard","hc"]
#   network7             = module.vpc.network_self_link
#   subnet-7-name        = module.vpc.subnet-name1
#   # ---------------------- LABELS ---------------------- #
#   project7             = "tac"
#   role7                = "tactpm-tstgui01"
#   env7                 = "web-dev-tac"
#   owner7               = "devops"
#   terraform7           = "yes"
#   name7                = "tactpm-tstgui01"
#   schedule7            = "yes"

#  # ---------------------- tactpm-tstapi01 ---------------------- #
#   vm8                  = "tactpm-tstapi01"
#   machine_type8        = "n1-standard-1"
#   vm_zone8             = "northamerica-northeast1-a"
#   image8               = "projects/web-dev-tac/global/images/tactpm-tstapi01-image-13-12-2024"
#   size8                = "20"
#   type8                = "pd-standard"
#   ip_forwarding8       = "false"
#   deletion_protection8 = "true"
#   tags8                = ["ssh","dashboard","hc"]
#   network8             = module.vpc.network_self_link
#   subnet-8-name        = module.vpc.subnet-name3
#   # ---------------------- LABELS ---------------------- #
#   project8             = "tac"
#   role8                = "tactpm-tstapi01"
#   env8                 = "web-dev-tac"
#   owner8               = "devops"
#   terraform8           = "yes"
#   name8                = "tactpm-tstapi01"
#   schedule8            = "yes"


# }

# module "firewall" {
#   source = "./modules/firewall/"

#   # ---------------------- tac-dev-rdp ----------------------
#   firewall_name1 = "tac-dev-rdp"
#   vpc_network1   = module.vpc.network_self_link
#   protocol1      = "tcp"
#   ports1         = ["3389","4444"]
#   target_tags1   = ["rdp"]
#   source_ranges1 = ["35.235.240.0/20"]

#   # ---------------------- tac-dev-ssh ----------------------

#   firewall_name2 = "tac-dev-ssh"
#   vpc_network2   = module.vpc.network_self_link
#   protocol2      = "tcp"
#   ports2         = ["22",]
#   target_tags2   = ["ssh"]
#   source_ranges2 = ["35.235.240.0/20"]


#  # ---------------------- tac-dev-dashboard ----------------------#
#   firewall_name3 = "tac-dev-dashboard"
#   vpc_network3   = module.vpc.network_self_link
#   protocol3      = "tcp"
#   ports3         = ["3001","3000","8000","80","5000"]
#   target_tags3   = ["dashboard"]
#   source_ranges3 = ["10.163.148.136/32","10.163.148.3/32"]


# # ---------------------- tac-dev-ad ----------------------#
#   firewall_name4 = "tac-dev-ad"
#   vpc_network4   = module.vpc.network_self_link
#   protocol4      = "all"
#   #ports3         = ["5432", "5433"]
#   target_tags4   = ["ad"]
#   source_ranges4 = ["10.163.148.128/27"]

# # ---------------------- tac-dev-lb-hc ----------------------#
#   firewall_name5 = "tac-dev-lb-hc"
#   vpc_network5   = module.vpc.network_self_link
#   protocol5      = "tcp"
#   ports5         = ["80"]
#   target_tags5   = ["hc"]
#   source_ranges5 = ["130.211.0.0/22","35.191.0.0/16"]

# }


# module "nat" {
#   source      = "./modules/nat/"

#   nat_ip_name           = "tac-dv-vpc-nat-ip"
#   nat_region            = "northamerica-northeast1"
#   router_name           = "tac-dv-router"
#   router_region         = "northamerica-northeast1"
#   vpc_network           = module.vpc.network_self_link
#   router_nat_name       = "tac-dv-vpc-nat"
#   subnet_to_nat         = module.vpc.subnet-name5
#   subnet_to_nat_iprange = module.vpc.subnet5-range
#   subnet_to_nat1         = module.vpc.subnet-name3
#   subnet_to_nat_iprange1 = module.vpc.subnet3-range


# }

# module "snapshot-schedule" {
#   source = "./modules/snapshot-schedule/"
#   # ---------------------- tac-dev-vm-backup-scheduling ---------------------- 
#   ssname1                = "tac-dev-vm-backup-scheduling"
#   region1                = "northamerica-northeast1"
#   days_in_cycle1         = "1"
#   start_time1            = "02:00"
#   max_retention_days1    = "10"
#   on_source_disk_delete1 = "KEEP_AUTO_SNAPSHOTS"
#   storage_locations1     = "northamerica-northeast1"

#   # ---------------------- labels ---------------------- 
#   name1      = "tac-dev-vm-backup-scheduling"
#   project1   = "tac"
#   role1      = "vm-backup"
#   env1       = "web-dev-tac"
#   owner1     = "devops"
#   terraform1 = "yes"

# }

# module "cloudsql" {
#   source          = "./modules/sql/"
#   ###-----tac-dv-db------###
#   db-name         = "tac-dv-db"
#   db-version      = "POSTGRES_14"
#   db-tier         = "db-custom-1-4096"
#   region          = "northamerica-northeast1"
#   zone            = "northamerica-northeast1-a"
#   disk-autoresize = "true"
#   disk-type       = "PD_SSD"
#   ipv4-enabled    = "false"
#   disk-size       = "10"
#   avail_type      = "ZONAL"
#   private-ip-name = "tac-dev-telus-sql-ip"
#   sql_vpc_network = module.vpc.network_self_link
  
#   # root_password = "admin123"
#   # activation-policy = "ALWAYS"
#   # sql_deletion_protection = "true"

#   # ---------------------- automatic backup ----------------------
#   backup_enabled                 = "true"
#   backup_location                = "us"
#   start_time                     = "17:00"
#   point_in_time_recovery_enabled = "true"

#   # ---------------------- maintenance window ----------------------
#   day           = "6"
#   hour          = "17"
#   update_track  = "stable"
#   project       = "web-dev-tac"
#   role          = "web-dev-tac"
#   env           = "web-dev-tac"
#   owner         = "devops"
#   terraform     = "yes"
#   project_owner = "devops"
#   requester     = "vijayant"

# ###---tac-qa-db----###
#   db-name1         = "tac-qa-db"
#   db-version1      = "POSTGRES_14"
#   db-tier1         = "db-custom-1-4096"
#   region1          = "northamerica-northeast1"
#   zone1            = "northamerica-northeast1-a"
#   disk-autoresize1 = "true"
#   disk-type1       = "PD_SSD"
#   ipv4-enabled1    = "false"
#   disk-size1       = "10"
#   avail_type1      = "ZONAL"
#   #private-ip-name1 = "tac-qa-telus-sql-ip"
#   sql_vpc_network1 = module.vpc.network_self_link
  
#   # root_password = "admin123"
#   # activation-policy = "ALWAYS"
#   # sql_deletion_protection = "true"

#   # ---------------------- automatic backup ----------------------
#   backup_enabled1                 = "true"
#   backup_location1                = "us"
#   start_time1                     = "17:00"
#   point_in_time_recovery_enabled1 = "true"

#   # ---------------------- maintenance window ----------------------
#   day1           = "6"
#   hour1          = "17"
#   update_track1  = "stable"
#   project1       = "web-dev-tac"
#   role1          = "web-dev-tac"
#   env1           = "web-dev-tac"
#   owner1         = "devops"
#   terraform1     = "yes"
#   project_owner1 = "devops"
#   requester1     = "vijayant"
  
# }

# module "lb" {
#   source = "./modules/loadbalancer/"
#   #---------------------- tac-dev-ig ----------------------#
#   igname1        = "vm-dvgui01-dev-ig"
#   igdescription1 = "import vm-dvgui01-dev vms"
#   igzone1        = "northamerica-northeast1-a"
#   iginstances1   = [module.vm.vm-dvgui01-dev_self_link]

#   igname2        = "vm-dvapi01-dev-ig"
#   igdescription2 = "import vm-dvapi01-dev vms"
#   igzone2        = "northamerica-northeast1-a"
#   iginstances2   = [module.vm.vm-dvapi01-dev_self_link]


#   # ---------------------- tac-dev-lb-hc ---------------------- 
#   health_check_name = "tac-dev-lb-hc"
#   # # ---------------------- dvgui01-backend ---------------------- 
#   backend_service_name1 = "vm-dvgui01-dev-backend"

#   # ---------------------- dvapi01-backend ---------------------- 
#   backend_service_name2 = "vm-dvapi01-dev-backend"

#   # ---------------------- tac-dev-lb-fr ---------------------- 
#   name1 = "tac-dev"

# }