const express = require('express');
const connectDB = require('./dtb');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const userRoutes = require('./routes/user');
const supportRoutes = require('./routes/customer_support');

const app = express();
const PORT = 3001;

app.use(cors());
app.use(express.json());
app.use(bodyParser.json());

// Kết nối MongoDB
connectDB();

// Routes
app.use('/api/users', userRoutes);
app.use('/api/customer-support', supportRoutes);

// Khởi chạy server
app.listen(PORT, () => {
    console.log(`🚀 OrderingService chạy trên cổng ${PORT}`);
});
