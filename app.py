from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, This is a mini K8s code which used to test K8s deployment</p>"