const mongoose = require('mongoose');

const addressSchema = new mongoose.Schema({
  receiver_name: { type: String, required: true },
  phone: { type: String, required: true },
  address: { type: String, required: true },
  commune: { type: String },
  district: { type: String },
  city: { type: String },
  default: { type: Boolean, default: false },
}, { _id: false });

const userSchema = new mongoose.Schema({
  email: { type: String, required: true },
  name: { type: String, required: true },
  password: { type: String, required: true },
  address: [addressSchema], // <== đổi từ String sang mảng đối tượng address
  role: { type: String, enum: ['admin', 'customer'], default: 'customer' },
  time_create: { type: Date, default: Date.now },
});

module.exports = mongoose.model('User', userSchema);
