const express = require('express');
const router = express.Router();
const CustomerSupport = require('../models/CustomerSupport');

// Tạo mới phiên chat hoặc thêm tin nhắn vào phiên chat đã có
router.post('/support/sendMessage', async (req, res) => {
  const { customer_email, text, image, isUser } = req.body;

  try {
    // Tìm phiên chat hiện tại
    let chat = await CustomerSupport.findOne({ customer_email });

    if (!chat) {
      // Nếu chưa có, tạo mới phiên chat
      chat = new CustomerSupport({
        customer_email,
        messages: [],
      });
    }

    // Thêm tin nhắn mới vào phiên chat
    chat.messages.push({ text, isUser, image });
    await chat.save();

    res.status(200).json({
      message: chat.messages.length === 1
        ? 'Chat created and message added'
        : 'Message added to existing chat',
      chatId: chat._id
    });

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});

module.exports = router;
