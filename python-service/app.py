import os
import logging
import flask
from flask import request, jsonify
from flask_cors import CORS

logging.basicConfig(level=logging.INFO)

app = flask.Flask(__name__)
CORS(app)

@app.route('/order', methods=['POST', 'GET'])
def neworder():
    app.logger.info('order service called')
    
    try:
        id = request.args.get('id')
        if id:
            resp = jsonify({ 'foo': 'bar'})
            resp.status_code = 200
            return resp
        else:
            resp = jsonify('User "id" not found in query string')
            resp.status_code = 500
            return resp
    except Exception as e:
	    print(e)
    finally:
        print('completed order service')
	
app.run(host='0.0.0.0', port=5000)