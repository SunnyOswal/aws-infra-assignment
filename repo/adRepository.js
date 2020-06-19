'use strict';

const Ad = require('../json/ad');

class AdRepository {
  constructor() {
    this.ads = new Map([
      [1, new Ad(1, 100, 'USD')],
      [2, new Ad(1, 200, 'HKD')]
    ]);
    this.nextId = 3;
  }

  getAll() {
    return Array.from(this.ads.values());
  }

  save(ad) {
      ad.id = ad.id || this.nextId++;
      this.ads.set(ad.id, ad);
      return 'Added Ad with id=' + ad.id;
    }
}

const adRepository = new AdRepository();

module.exports = adRepository;
