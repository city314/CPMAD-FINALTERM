const express = require('express');
const connectDB = require('./dtb');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const categoryRoutes = require('./routes/category');
const brandRoutes = require('./routes/brand');

const app = express();
const PORT = 3002;

app.use(cors());
app.use(express.json());
app.use(bodyParser.json());

connectDB(); // Kết nối MongoDB

// Routes
app.use('/api/category', categoryRoutes);
app.use('/api/brand', brandRoutes);

// Khởi chạy server
app.listen(PORT, () => {
    console.log(`🚀 CategoryService chạy trên cổng ${PORT}`);
});
