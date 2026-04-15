FROM node:18-alpine

# Creamos el directorio de trabajo
WORKDIR /app

# Copiamos los archivos de dependencias (si tienes package.json)
COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 4002

CMD ["node", "index.js"]