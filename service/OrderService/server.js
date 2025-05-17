const express = require('express');
const connectDB = require('./dtb');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const couponRoutes = require('./routes/coupon');
const cartRoutes = require('./routes/cart');

const app = express();
const PORT = 3003;

app.use(cors());
app.use(express.json());
app.use(bodyParser.json());

// Kết nối MongoDB
connectDB();

// Routes
app.use('/api/coupons', couponRoutes);
app.use('/api/carts', cartRoutes);

// Khởi chạy server
app.listen(PORT, () => {
    console.log(`🚀 OrderService chạy trên cổng ${PORT}`);
});
