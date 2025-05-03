const mongoose = require('mongoose');

const loyaltyPointSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  points: Number,
  time_create: { type: Date, default: Date.now },
});

module.exports = mongoose.model('LoyaltyPoint', loyaltyPointSchema);
