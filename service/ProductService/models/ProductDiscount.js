const mongoose = require('mongoose');

const productDiscountSchema = new mongoose.Schema({
  product_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
  discount_percent: Number,
  start_date: Date,
  end_date: Date,
});

module.exports = mongoose.model('ProductDiscount', productDiscountSchema);
