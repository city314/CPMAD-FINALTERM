const express = require('express');
const router = express.Router();
const Cart = require('../models/Cart');

// Lấy giỏ hàng theo user_id
router.get('/:userId', async (req, res) => {
  try {
    const cart = await Cart.findOne({ user_id: req.params.userId });
    res.json(cart || { user_id: req.params.userId, items: [] });
  } catch (err) {
    res.status(500).json({ error: 'Lỗi server' });
  }
});

// Thêm hoặc cập nhật item trong giỏ hàng
router.post('/add', async (req, res) => {
  const { user_id, variant_id, quantity } = req.body;
  if (!user_id || !variant_id || !quantity) {
    return res.status(400).json({ error: 'Thiếu dữ liệu' });
  }

  try {
    let cart = await Cart.findOne({ user_id });

    if (!cart) {
      cart = new Cart({
        user_id,
        items: [{ variant_id, quantity }]
      });
    } else {
      const index = cart.items.findIndex(item => item.variant_id === variant_id);
      if (index >= 0) {
        cart.items[index].quantity += quantity;
      } else {
        cart.items.push({ variant_id, quantity });
      }
    }

    await cart.save();
    res.json(cart);
  } catch (err) {
    res.status(500).json({ error: 'Lỗi server' });
  }
});

// Cập nhật số lượng của một item
router.put('/update', async (req, res) => {
  const { user_id, variant_id, quantity } = req.body;
  if (!user_id || !variant_id || quantity == null) {
    return res.status(400).json({ error: 'Thiếu dữ liệu' });
  }

  try {
    const cart = await Cart.findOne({ user_id });
    if (!cart) return res.status(404).json({ error: 'Không tìm thấy giỏ hàng' });

    const index = cart.items.findIndex(item => item.variant_id === variant_id);
    if (index === -1) return res.status(404).json({ error: 'Sản phẩm không có trong giỏ hàng' });

    cart.items[index].quantity = quantity;
    await cart.save();
    res.json(cart);
  } catch (err) {
    res.status(500).json({ error: 'Lỗi server' });
  }
});

// Xóa một item khỏi giỏ
router.delete('/remove', async (req, res) => {
  const { user_id, variant_id } = req.body;
  if (!user_id || !variant_id) {
    return res.status(400).json({ error: 'Thiếu dữ liệu' });
  }

  try {
    const cart = await Cart.findOne({ user_id });
    if (!cart) return res.status(404).json({ error: 'Không tìm thấy giỏ hàng' });

    cart.items = cart.items.filter(item => item.variant_id !== variant_id);
    await cart.save();
    res.json(cart);
  } catch (err) {
    res.status(500).json({ error: 'Lỗi server' });
  }
});

// Xóa toàn bộ giỏ hàng
router.delete('/clear/:userId', async (req, res) => {
  try {
    const result = await Cart.deleteOne({ user_id: req.params.userId });
    res.json({ success: result.deletedCount > 0 });
  } catch (err) {
    res.status(500).json({ error: 'Lỗi server' });
  }
});

router.post('/create', async (req, res) => {
  const { user_id, items } = req.body;

  if (!user_id || !Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ error: 'Thiếu user_id hoặc danh sách items' });
  }

  try {
    // Kiểm tra nếu đã có giỏ hàng thì không tạo lại
    const existingCart = await Cart.findOne({ user_id });
    if (existingCart) {
      return res.status(409).json({ error: 'Giỏ hàng đã tồn tại' });
    }

    const cart = new Cart({
      user_id,
      items, // [{ variant_id, quantity }]
      time_add: new Date()
    });

    await cart.save();
    return res.status(201).json(cart);
  } catch (error) {
    console.error('❌ Lỗi tạo giỏ hàng:', error);
    return res.status(500).json({ error: 'Lỗi server' });
  }
});

module.exports = router;
