const express = require('express');
const connectDB = require('./dtb');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const categoryRoutes = require('./routes/category');
const brandRoutes = require('./routes/brand');
const productRoutes = require('./routes/product');
const variantRoutes = require('./routes/variant');

const app = express();
const PORT = 3002;

app.use(cors());
app.use(bodyParser.json({ limit: '20mb' }));
app.use(bodyParser.urlencoded({ limit: '20mb', extended: true }));

connectDB(); // Kết nối MongoDB

// Routes
app.use('/api/category', categoryRoutes);
app.use('/api/brands', brandRoutes);
app.use('/api/products', productRoutes);
app.use('/api/variants', variantRoutes);

// Khởi chạy server
app.listen(PORT, () => {
    console.log(`🚀 CategoryService chạy trên cổng ${PORT}`);
});
