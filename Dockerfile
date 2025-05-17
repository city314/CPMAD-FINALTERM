# 1) Builder: pull Flutter from Git (stable channel)
FROM ubuntu:22.04 AS builder

# install deps
RUN apt-get update && \
    apt-get install -y curl git unzip xz-utils libglu1-mesa build-essential

# clone the Flutter repo from stable channel
RUN git clone --branch stable --depth 1 https://github.com/flutter/flutter.git /opt/flutter

# fix Git “dubious ownership” error inside /opt/flutter
RUN git config --global --add safe.directory /opt/flutter

# add Flutter to PATH
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

# enable web
RUN flutter config --enable-web

WORKDIR /app

# copy only pubspec to leverage Docker cache
COPY pubspec.* ./
RUN flutter pub get

# copy everything else
COPY . .

# build the web app
RUN flutter build web --release

# 2) Nginx stage: serve the built web files
FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
