const mongoose = require('mongoose');

const variantSchema = new mongoose.Schema({
  product_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Product', required: true },
  variant_name: { type: String, required: true },
  attributes: { type: mongoose.Schema.Types.Mixed, default: {}},
  price: { type: Number, required: true },
  stock: { type: Number, required: true },
  sku: { type: String, default: '' },
  image_url: { type: String, default: '' },
}, { timestamps: true });

module.exports = mongoose.model('Variant', variantSchema);
