const mongoose = require('mongoose');

const productImageSchema = new mongoose.Schema({
  product_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
  image_url: String,
});

module.exports = mongoose.model('ProductImage', productImageSchema);
