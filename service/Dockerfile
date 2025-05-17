# 1. Chọn image gọn nhẹ
FROM node:18-alpine

# 2. Tạo và chuyển vào thư mục làm việc
WORKDIR /app

# 3. Copy package.json và cài dependencies
COPY package*.json ./
RUN npm install --production

# 4. Copy toàn bộ code
COPY . .

# 5. Mở port (phù hợp với server của bạn)
EXPOSE 3000

# 6. Chạy app
CMD ["node", "index.js"]
