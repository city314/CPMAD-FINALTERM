const express = require('express');
const Product = require('../models/Product');
const Category = require('../models/Category');
const Brand = require('../models/Brand');
const router = express.Router();

// GET all products
router.get('/', async (req, res) => {
  try {
    const products = await Product.find();

    // Lấy thông tin category và brand cho mỗi sản phẩm
    const enriched = await Promise.all(products.map(async (p) => {
      const category = await Category.findById(p.categoryId).lean();
      const brand = await Brand.findById(p.brandId).lean();

      return {
        ...p.toObject(),
        categoryName: category?.name ?? '',
        brandName: brand?.name ?? '',
      };
    }));

    res.json(enriched);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Lỗi khi lấy danh sách sản phẩm' });
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
    const deleted = await Product.findByIdAndDelete(req.params.id);
    if (!deleted) return res.status(404).json({ message: 'Không tìm thấy sản phẩm' });
    res.json({ message: 'Đã xoá sản phẩm' });
  } catch (e) {
    res.status(500).json({ message: 'Xoá thất bại', error: e });
  }
});

module.exports = router;
