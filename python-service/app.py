import os
import logging
import flask
from flask import request, jsonify
from flask_cors import CORS

logging.basicConfig(level=logging.INFO)

app = flask.Flask(__name__)
CORS(app)

@app.route('/hello', methods=['POST', 'GET'])
def neworder():
    app.logger.info('container called')
    return f">> hello from python flask! container id: {os.getenv('POD_NAME')} at internal ip {os.getenv('POD_IP')}"
app.run(host='0.0.0.0')