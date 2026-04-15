const express = require('express');
const mysql = require('mysql2');
const app = express();
// El puerto cambia según el entorno (4002 o 5002)
const port = process.env.PORT || 4002;

const connection = mysql.createConnection({
  host: 'bd',
  user: 'root',
  password: 'password',
  database: 'laboratorio_db'
});

app.get('/', (req, res) => {
  connection.query('SELECT "Conexión Exitosa" AS mensaje', (err, results) => {
    if (err) return res.status(500).send('Error de BD: ' + err.message);
    res.send(`API puerto ${port}: ${results[0].mensaje}`);
  });
});

app.listen(port, () => console.log(`Puerto ${port} activo`));