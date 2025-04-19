const mongoose = require('mongoose');

const couponUsageOrderSchema = new mongoose.Schema({
  order_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Order' },
  coupon_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Coupon' },
  time_used: { type: Date, default: Date.now },
});

module.exports = mongoose.model('CouponUsageOrder', couponUsageOrderSchema);
