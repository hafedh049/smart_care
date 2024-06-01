from flask import Flask,jsonify,request
import json

_app = Flask(__name__)


@_app.route("/delete_user",methods=['POST'])
def delete_user():
    print(json.loads(request.data.decode()))
    return jsonify({"message":"success"})


if __name__ == '__main__':
    _app.run(host="0.0.0.0",debug=True,port=80)