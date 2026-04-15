const express = require('express');
const app = express();
const port = 4002;

app.get('/', (req, res) => {
  res.send('API (api01) funcionando correctamente en Node.js');
});

app.listen(port, () => {
  console.log(`Servidor backend escuchando en http://localhost:${port}`);
});