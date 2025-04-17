const mongoose = require('mongoose');

const couponSchema = new mongoose.Schema({
  code: String,
  discount_amount: Number,
  usage_max: Number,
  usage_times: Number,
  time_create: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Coupon', couponSchema);
