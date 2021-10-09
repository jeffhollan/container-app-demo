var express = require('express');
var router = express.Router();
const axios = require('axios').default;
const inventoryService = `http://localhost:${process.env.DAPR_HTTP_PORT}/v1.0/invoke/${process.env.INVENTORY_SERVICE_NAME}/method`

/* GET users listing. */
router.get('/', async function(req, res, next) {
  var data = await axios.get(`${inventoryService}/inventory?id=${req.query.id}`);
  res.send(`inventory status for ${req.query.id}:\n${data.data}`);
});

module.exports = router;
