const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null },
  total_price: Number,
  loyalty_point_used: Number,
  discount: Number,
  tax: Number,
  shipping_fee: Number,
  final_price: Number,
  status: { type: String, enum: ['pending', 'complete', 'canceled', 'shipped', 'paid'] },
  time_create: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Order', orderSchema);
