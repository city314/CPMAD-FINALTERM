const express = require('express');
const router = express.Router();
const Coupon = require('../models/Coupon');

// GET all coupons
router.get('/', async (req, res) => {
  try {
    const coupons = await Coupon.find().sort({ timeCreate: -1 });
    res.json(coupons);
  } catch (err) {
    res.status(500).json({ message: 'Lỗi server', error: err });
  }
});

// POST: Create new coupon
router.post('/', async (req, res) => {
  try {
    const { code, discount_amount, usage_max } = req.body;
    const exists = await Coupon.findOne({ code });
    if (exists) {
      return res.status(400).json({ message: 'Mã coupon đã tồn tại' });
    }
    const newCoupon = new Coupon({
      code,
      discount_amount,
      usage_max,
      usage_times: 0,
      time_create: new Date(),
    });
    await newCoupon.save();
    res.status(201).json(newCoupon);
  }
  catch (err) {
    console.error('CREATE ERROR:', err); // ✅ in log rõ hơn
    res.status(500).json({ message: 'Không thể tạo coupon', error: err.message || err });
  }
});

// PUT: Update existing coupon
router.put('/:id', async (req, res) => {
  try {
    const { code, discount_amount, usage_max } = req.body;
    const updated = await Coupon.findByIdAndUpdate(
      req.params.id,
      { code, discount_amount, usage_max },
      { new: true }
    );
    if (!updated) return res.status(404).json({ message: 'Không tìm thấy coupon' });
    res.json(updated);
  } catch (err) {
    res.status(500).json({ message: 'Không thể cập nhật coupon', error: err });
  }
});

// DELETE: Remove coupon
router.delete('/:id', async (req, res) => {
  try {
    const deleted = await Coupon.findByIdAndDelete(req.params.id);
    if (!deleted) return res.status(404).json({ message: 'Không tìm thấy coupon' });
    res.json({ message: 'Đã xoá coupon', deleted });
  } catch (err) {
    res.status(500).json({ message: 'Không thể xoá coupon', error: err });
  }
});

module.exports = router;
