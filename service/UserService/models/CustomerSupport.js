const mongoose = require('mongoose');

const supportSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  admin_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  message: String,
  sent_by: { type: String, enum: ['admin', 'user'] },
  time_sent: { type: Date, default: Date.now },
});

module.exports = mongoose.model('CustomerSupport', supportSchema);
