# ----------------------------
# Stage 1: Build Flutter Web
# ----------------------------
FROM ghcr.io/cirruslabs/flutter:stable AS flutter_builder
WORKDIR /app

# Copy pubspec để tận dụng cache
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy toàn bộ source Flutter và build web
COPY . .
RUN flutter build web --release

# -----------------------------------
# Stage 2: Build và package Node.js
# -----------------------------------
FROM node:20-alpine AS node_builder
WORKDIR /app

# Copy file package.json, cài dependencies
COPY server/package*.json ./
RUN npm install --production

# Copy toàn bộ source backend vào
COPY server/. .

# Copy Flutter web build vào thư mục public
COPY --from=flutter_builder /app/build/web ./public

# -----------------------------------
# Stage 3: Final image chạy production
# -----------------------------------
FROM node:20-alpine
WORKDIR /app

# Copy toàn bộ từ node_builder
COPY --from=node_builder /app ./

# Mở port backend
EXPOSE 3000

# Chạy server
CMD ["npm", "start"]
