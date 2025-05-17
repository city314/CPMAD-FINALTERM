FROM node:18-alpine
WORKDIR /app

# Copy only the service folder’s package files
COPY service/package*.json ./
RUN npm install --production

# Copy the rest of the service code
COPY service ./

EXPOSE 3000
CMD ["node", "index.js"]
