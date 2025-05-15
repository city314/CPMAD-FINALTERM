const mongoose = require('mongoose');

const cartSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null
  },
  session_id: {
    type: String,
    required: true
  },
  product_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Product',
    required: true
  },
  variant_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Variant',
    required: true
  },
  quantity: {
    type: Number,
    required: true,
    default: 1,
    min: 1
  },
  time_add: {
    type: Date,
    default: Date.now
  }
});

// Optional: tạo index để tìm nhanh theo user hoặc session
cartSchema.index({ user_id: 1, session_id: 1 });

module.exports = mongoose.model('Cart', cartSchema);