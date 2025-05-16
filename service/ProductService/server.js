const express = require('express');
const connectDB = require('./dtb');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const http = require('http');
const socketIo = require('socket.io');

const categoryRoutes = require('./routes/category');
const brandRoutes = require('./routes/brand');
const productRoutes = require('./routes/product');
const variantRoutes = require('./routes/variant');
const reviewRoutes = require('./routes/review');

const app = express();
const PORT = 3002;

const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: '*',
  }
});
app.set('io', io);

// Khi có kết nối mới
io.on('connection', socket => {
  console.log('A user connected');

  socket.on('sendReview', async (review) => {
    io.emit('newReview', review); // phát tới tất cả client
  });

  socket.on('disconnect', () => {
    console.log('A user disconnected');
  });
});

app.use(cors());
app.use(bodyParser.json({ limit: '20mb' }));
app.use(bodyParser.urlencoded({ limit: '20mb', extended: true }));

connectDB(); // Kết nối MongoDB

// Routes
app.use('/api/category', categoryRoutes);
app.use('/api/brands', brandRoutes);
app.use('/api/products', productRoutes);
app.use('/api/variants', variantRoutes);
app.use('/api/reviews', reviewRoutes);

// Khởi chạy server
server.listen(PORT, () => {
    console.log(`🚀 CategoryService chạy trên cổng ${PORT}`);
});
