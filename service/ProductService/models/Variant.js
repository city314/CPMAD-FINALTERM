const mongoose = require('mongoose');

// Định nghĩa schema ảnh nhúng trực tiếp
const variantImageSchema = new mongoose.Schema({
  image_url: { type: String, required: true }
}, { _id: false }); // không cần _id riêng cho mỗi ảnh

const variantSchema = new mongoose.Schema({
  product_id: { type: String, required: true },
  variant_name: { type: String, required: true },
  color: { type: String, default: 'black' },
  attributes: { type: String, required: true }, // cho nhập tay như description
  price: { type: Number, required: true },
  stock: { type: Number, required: true },
  images: [variantImageSchema],
}, { timestamps: true });

module.exports = mongoose.model('Variant', variantSchema);
