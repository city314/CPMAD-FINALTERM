const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: String,
  category_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Category' },
  brand: String,
  price: Number,
  description: String,
  stock: Number,
});

module.exports = mongoose.model('Product', productSchema);
