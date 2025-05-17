# Stage 1: build Flutter web
FROM ubuntu:22.04 AS builder
RUN apt-get update && apt-get install -y curl unzip xz-utils git libglu1-mesa build-essential
# Download Flutter SDK
RUN curl -Lo flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.7.12-stable.tar.xz \
  && tar xf flutter.tar.xz -C /opt
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter config --enable-web

WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# Stage 2: serve via nginx
FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
