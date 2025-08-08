from flask import Flask, request
from domo_loader import main_fn

app = Flask(__name__)

@app.route("/", methods=["GET", "POST"])
def handler():
    return main_fn(request)