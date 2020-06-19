'use strict';

const express = require('express');
const bodyParser = require('body-parser');
const config = require('./config/config');
const app = new express();

app.use(bodyParser.json());

require('./config/cors')(app);
require('./routes/adRoutes')(app);

app.listen(3000, () => {
  console.log('Ad Service is up & running !');
});
