'use strict';

const Router = require('express');
const adRepo = require('../repo/adRepository');

const getAdRoutes = app => {
  
  app.get('/ad', (req, res) => {
         
         const reqUrl = req.protocol + '://' + req.headers.host + req.url;
         console.log(req.method + ' Request: ' + reqUrl);

         const result = adRepo.getAll();
         res.send(result);
  })
  
  app.post('/ad-event', (req, res) => {

         const reqUrl = req.protocol + '://' + req.headers.host + req.url;
         console.log(req.method + ' Request: ' + reqUrl);
         console.log('Request Body : ' + JSON.stringify(req.body, null, 2));

         const ad = req.body;
         const result = adRepo.save(ad);
         res.send(result);
  })
};

module.exports = getAdRoutes;
