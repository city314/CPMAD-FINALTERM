const express = require('express');
const router = express.Router();
const Variant = require('../models/Variant');

// GET all variants (optional)
router.get('/', async (req, res) => {
  try {
    const variants = await Variant.find();
    res.json(variants);
  } catch (err) {
    res.status(500).json({ message: 'Lỗi lấy danh sách biến thể', error: err });
  }
});

router.get('/by-product/:productId', async (req, res) => {
  try {
    const variants = await Variant.find({ product_id: req.params.productId });
    res.json(variants);
  } catch (err) {
    res.status(500).json({ message: 'Lỗi lấy biến thể', error: err });
  }
});

// POST: create new variant
router.post('/', async (req, res) => {
  try {
    const variant = new Variant(req.body);
    await variant.save();
    res.status(201).json(variant);
  } catch (err) {
    res.status(400).json({ message: 'Tạo biến thể thất bại', error: err });
  }
});

// PUT: update variant
router.put('/:id', async (req, res) => {
  try {
    const updated = await Variant.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updated) return res.status(404).json({ message: 'Không tìm thấy biến thể' });
    res.json(updated);
  } catch (err) {
    res.status(400).json({ message: 'Cập nhật thất bại', error: err });
  }
});

// DELETE: delete variant
router.delete('/:id', async (req, res) => {
  try {
    const deleted = await Variant.findByIdAndDelete(req.params.id);
    if (!deleted) return res.status(404).json({ message: 'Không tìm thấy biến thể' });
    res.json({ message: 'Đã xoá biến thể' });
  } catch (err) {
    res.status(500).json({ message: 'Xoá thất bại', error: err });
  }
});

module.exports = router;
