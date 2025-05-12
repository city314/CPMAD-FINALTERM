const mongoose = require('mongoose');

const MessageSchema = new mongoose.Schema({
  text: String,
  isUser: Boolean,
  time: { type: Date, default: Date.now }
});

const supportSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  messages: [MessageSchema],
  sent_by: { type: String, enum: ['admin', 'user'] },
  time_sent: { type: Date, default: Date.now },
});

module.exports = mongoose.model('CustomerSupport', supportSchema);
