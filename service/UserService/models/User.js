const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: String,
  name: String,
  password: String,
  address: String,
  role: { type: String, enum: ['admin', 'customer'] },
  time_create: { type: Date, default: Date.now },
});

module.exports = mongoose.model('User', userSchema);
