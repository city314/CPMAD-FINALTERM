# STAGE 1: Build Flutter Web
FROM cirrusci/flutter:3.7.12-stable AS builder
RUN flutter config --enable-web

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .
RUN flutter build web --release

FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html

