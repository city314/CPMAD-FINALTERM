const express = require('express');
const Product = require('../models/Product');
const Category = require('../models/Category');
const Brand = require('../models/Brand');
const Variant = require('../models/Variant');
const router = express.Router();

// GET all products
const mongoose = require('mongoose');

router.get('/', async (req, res) => {
  try {
    const products = await Product.find();

    const result = await Promise.all(products.map(async (p) => {
      const brand = await Brand.findById(p.brand_id);
      const category = await Category.findById(p.category_id);

      const variants = await Variant.find({ product_id: p._id });

      // Tìm giá thấp nhất trong các biến thể (giá bán)
      const lowestPrice = variants.length > 0
        ? Math.min(...variants.map(v => v.sellingPrice || Infinity))
        : 0;

      return {
        ...p.toObject(),
        brandName: brand?.name || '',
        categoryName: category?.name || '',
        variantCount: variants.length,
        lowestPrice,
      };
    }));

    res.json(result);
  } catch (err) {
    res.status(500).json({ message: 'Lỗi lấy danh sách sản phẩm', error: err });
  }
});

// POST create product
router.post('/', async (req, res) => {
  try {
    const newProduct = new Product(req.body);
    await newProduct.save();
    res.status(201).json(newProduct);
  } catch (e) {
    res.status(400).json({ message: 'Tạo sản phẩm thất bại', error: e });
  }
});

// PUT update product
router.put('/:id', async (req, res) => {
  try {
    const updated = await Product.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updated) return res.status(404).json({ message: 'Không tìm thấy sản phẩm' });
    res.json(updated);
  } catch (e) {
    res.status(400).json({ message: 'Cập nhật thất bại', error: e });
  }
});

// DELETE product
router.delete('/:id', async (req, res) => {
  try {
    const productId = req.params.id;

    // Xóa các biến thể trước
    await Variant.deleteMany({ productId });

    // Sau đó xóa sản phẩm
    await Product.findByIdAndDelete(productId);

    res.json({ message: 'Xóa sản phẩm và biến thể thành công' });
  } catch (err) {
    res.status(500).json({ message: 'Lỗi khi xóa sản phẩm', error: err });
  }
});

// PUT: Cập nhật discount_percent cho danh sách sản phẩm
router.put('/discounts/update', async (req, res) => {
  try {
    const { discounts } = req.body; // [{ productId: 'p001', discountPercent: 20 }, ...]

    if (!Array.isArray(discounts)) {
      return res.status(400).json({ message: 'Invalid data format' });
    }

    const updatePromises = discounts.map(item =>
      Product.updateOne(
        { _id: item.productId },
        { $set: { discount_percent: item.discountPercent } }
      )
    );

    await Promise.all(updatePromises);
    res.json({ message: 'Cập nhật giảm giá thành công' });
  } catch (error) {
    console.error('Update discounts error:', error);
    res.status(500).json({ message: 'Lỗi server' });
  }
});

module.exports = router;
