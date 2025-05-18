const express = require('express');
const connectDB = require('./dtb');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const couponRoutes = require('./routes/coupon');
const cartRoutes = require('./routes/cart');
const orderRoutes = require('./routes/order');
const orderDetailRoutes = require('./routes/orderdetail');
const orderStatusRoutes = require('./routes/orderstatushistory');
const couponUsageRoutes = require('./routes/couponusageorder');

const app = express();
const PORT = 3003;

app.use(cors());
app.use(express.json());
app.use(bodyParser.json());

// Kết nối MongoDB
connectDB();

// Dashboard
// 2. Import model Order (theo đúng path của bạn)
const Order = require('./models/Order');

// 3. Thêm route GET /api/orders/all để trả về toàn bộ orders
app.get('/api/orders/all', async (req, res) => {
  try {
    const orders = await Order.find();   // lấy tất cả đơn
    res.status(200).json(orders);
  } catch (err) {
    console.error('❌ Error fetching all orders:', err);
    res.status(500).json({
      message: 'Lỗi khi lấy danh sách đơn hàng',
      error: err.message
    });
  }
});

// Routes
app.use('/api/coupons', couponRoutes);
app.use('/api/carts', cartRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/orderdetails', orderDetailRoutes);
app.use('/api/order-status', orderStatusRoutes);
app.use('/api/coupon-usage', couponUsageRoutes);

// Khởi chạy server
app.listen(PORT, () => {
    console.log(`🚀 OrderService chạy trên cổng ${PORT}`);
});
