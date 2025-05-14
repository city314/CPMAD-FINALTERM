const mongoose = require('mongoose');

// Định nghĩa schema ảnh nhúng trực tiếp
const productImageSchema = new mongoose.Schema({
  image_url: { type: String, required: true }
}, { _id: false }); // không cần _id riêng cho mỗi ảnh

const productSchema = new mongoose.Schema({
  name: String,
  category_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Category' },
  brand: { type: String },
  price: Number,
  description: String,
  stock: Number,
  images: [productImageSchema],
});

module.exports = mongoose.model('Product', productSchema);
