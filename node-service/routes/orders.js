var express = require('express');
var router = express.Router();
const axios = require('axios').default;

const orderService = `http://localhost:${process.env.DAPR_HTTP_PORT}/v1.0/invoke/${process.env.ORDER_SERVICE_NAME}/method`

/* GET order by calling order microservice via dapr */
router.get('/', async function(req, res, next) {
  
  var data = await axios.get(`${orderService}/order?id=${req.query.id}`);
  
  res.send(`${JSON.stringify(data.data)}`);
});

/* POST create order by calling order microservice via dapr */
router.post('/', async function(req, res, next) {
  try{
    var order = req.body;
    order['location'] = 'Seattle';
    order['priority'] = 'Standard';
    var data = await axios.post(`${orderService}/order?id=${req.query.id}`, order);
  
    res.send(`<p>Order created!</p><br/><code>${JSON.stringify(data.data)}</code>`);
  }
  catch(err){
    res.send(`<p>Error creating order<br/>Order microservice or dapr may not be running.<br/></p><br/><code>${err}</code>`);
  }
});

module.exports = router;
