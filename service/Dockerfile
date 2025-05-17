FROM node:18-alpine
WORKDIR /app

COPY service/package*.json ./
RUN npm install --production

COPY service/ ./
EXPOSE 3000
CMD ["node","index.js"]

