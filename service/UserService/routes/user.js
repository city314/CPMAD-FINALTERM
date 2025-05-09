const express = require('express');
const router = express.Router();
const User = require('../models/User');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');

router.post('/register', async (req, res) => {
  const { email, name, password, address } = req.body;

  if (!email || !name || !password || !address) {
    return res.status(400).json({ message: 'Vui lòng nhập đầy đủ thông tin' });
  }

  const existingUser = await User.findOne({ email });
  if (existingUser) {
    return res.status(409).json({ message: 'Email đã tồn tại' });
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  const newUser = new User({
    email,
    name,
    password: hashedPassword,
    address,
    role: 'customer',
  });

  await newUser.save();
  return res.status(201).json({ message: 'Đăng ký thành công' });
});

router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password)
    return res.status(400).json({ message: 'Thiếu email hoặc mật khẩu' });

  const user = await User.findOne({ email });
  if (!user)
    return res.status(401).json({ message: 'Email không tồn tại' });

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch)
    return res.status(401).json({ message: 'Mật khẩu không đúng' });

//   const token = jwt.sign(
//     { userId: user._id, role: user.role },
//     'your_secret_key_here',
//     { expiresIn: '7d' }
//   );

  res.json({
    message: 'Đăng nhập thành công',
    // token,
    user: {
      id: user._id,
      name: user.name,
      email: user.email,
      role: user.role,
    },
  });
});

// Gửi mã OTP về email
router.post('/forgot-password', async (req, res) => {
  const { email } = req.body;

  try {
    // Kiểm tra email có tồn tại không
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: 'Email không tồn tại' });
    }

    // Tạo mã OTP ngẫu nhiên 6 chữ số
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();

//    // Lưu OTP và thời gian tạo (tuỳ cách bạn muốn lưu - tạm thời response cho đơn giản)
//    user.otpCode = otpCode;
//    user.otpExpires = Date.now() + 5 * 60 * 1000; // hết hạn sau 5 phút
//    await user.save();

    // Gửi email qua Nodemailer
    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: 'nhomcnpm1@gmail.com',
        pass: 'abfk znlx ggfn ycpk',
      },
    });

    const mailOptions = {
      from: 'Flutter@gmail.com',
      to: email,
      subject: 'OTP Reset Password',
      text: `Mã OTP đặt lại mật khẩu của bạn là: ${otpCode}`,
    };

    await transporter.sendMail(mailOptions);

    res.json({ message: 'OTP đã được gửi đến email của bạn', otp: otpCode});
  } catch (error) {
  console.error('Gửi mail lỗi:', error);
    res.status(500).json({ message: 'Lỗi server', error: error.message });
  }
});

router.post('/reset-password', async (req, res) => {
  const { email, newPassword } = req.body;

  if (!email || !newPassword) {
    return res.status(400).json({ message: 'Thiếu email hoặc mật khẩu mới' });
  }

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: 'Người dùng không tồn tại' });
    }

    const hashed = await bcrypt.hash(newPassword, 10);
    await User.updateOne(
      { email },
      { $set: { password: hashed } }
    );

    res.json({ message: 'Đặt lại mật khẩu thành công' });
  } catch (error) {
    console.error('Lỗi đổi mật khẩu:', error);
    res.status(500).json({ message: 'Lỗi server', error: error.message });
  }
});

module.exports = router;
