var express = require('express');
var router = express.Router();
const axios = require('axios').default;

const orderService = `http://localhost:${process.env.DAPR_HTTP_PORT}/v1.0/invoke/${process.env.ORDER_SERVICE_NAME}/method`

/* GET users listing. */
router.get('/', async function(req, res, next) {
  
  var data = await axios.get(`${orderService}/order?id=${req.query.id}`);
  
  res.send(`${JSON.stringify(data.data)}`);
});

/* GET users listing. */
router.post('/', async function(req, res, next) {
  
  var data = await axios.post(`${orderService}/order?id=${req.query.id}`, req.body);
  
  res.send(`${JSON.stringify(data.data)}`);
});

module.exports = router;
