import os
import logging
import flask
from flask import request, jsonify
from flask_cors import CORS
from dapr.clients import DaprClient

logging.basicConfig(level=logging.INFO)

app = flask.Flask(__name__)
CORS(app)

@app.route('/order', methods=['GET'])
def getOrder():
    app.logger.info('order service called')
    with DaprClient() as d:
        try:
            id = request.args.get('id')
            if id:
                # Get the order status from Cosmos DB via Dapr
                state = d.get_state(store_name='orders', key=id)
                # state = {'foo': 'bar'}
                resp = jsonify(state)
                resp.status_code = 200
                return resp
            else:
                resp = jsonify('Order "id" not found in query string')
                resp.status_code = 500
                return resp
        except Exception as e:
            print(e)
        finally:
            print('completed order service')

@app.route('/order', methods=['POST'])
def createOrder():
    app.logger.info('order service called')
    with DaprClient() as d:
        try:
            id = request.args.get('id')
            if id:
                # Save the order to Cosmos DB via Dapr
                d.save_state(store_name='orders', key=id, value=request.json)
                resp = request.json
                resp.status_code = 200
                return resp
            else:
                resp = jsonify('Order "id" not found in query string')
                resp.status_code = 500
                return resp
        except Exception as e:
            print(e)
        finally:
            print('created order')

app.run(host='0.0.0.0', port=5000)