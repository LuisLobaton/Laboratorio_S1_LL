FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Exponemos ambos por si acaso
EXPOSE 4002 5002
CMD ["node", "index.js"]