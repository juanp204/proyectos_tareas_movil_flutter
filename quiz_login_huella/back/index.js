const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const axios = require('axios'); // Utilizamos Axios para realizar solicitudes HTTP
const cors = require('cors')

const app = express();
const PORT = 3000;
const SECRET_KEY = 'your_secret_key'; 

app.use(cors());

// Middleware para parsear el cuerpo de las solicitudes
app.use(bodyParser.json());

// Endpoint para el login
app.post('/login', (req, res) => {
  console.log(req.body);
  const { username, password } = req.body; // Acceder al primer elemento del array
  console.log(req.body);

  console.log("login");
  // Leer usuarios desde el archivo JSON
  fs.readFile('users.json', 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
    const users = JSON.parse(data);
    console.log(users);
    // Verificar si el usuario y contraseña son válidos
    const user = users.find((u) => u.username === username && u.password === password);
    console.log(user);
    if (!user) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }
    const date = Date.now();
    // Generar token JWT
    const token = jwt.sign({ username, date }, SECRET_KEY, { expiresIn: '1h' }); // Token expira en 1 hora
    console.log(token);
    // Devolver el token en la respuesta
    res.json({ token });
  });
});

app.post('/habilitarhuella', verifyToken,(req, res) => {
  console.log(req.body);
  const { username, password } = req.body; // Acceder al primer elemento del array

  console.log("huella");
  // Leer usuarios desde el archivo JSON
  fs.readFile('users.json', 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
    const users = JSON.parse(data);
    console.log(users);
    // Verificar si el usuario y contraseña son válidos
    const user = users.find((u) => u.username === username && u.password === password);
    console.log(user);
    if (!user) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }
    const date = Date.now();
    // Generar token JWT
    const token = jwt.sign({ username, date }, SECRET_KEY); // Token expira en 1 hora
    console.log(token);
    // Devolver el token en la respuesta
    res.json({ token });
  });
});

app.post('/loginhuella', verifyToken,(req, res) => {

  console.log("huella");
  // Leer usuarios desde el archivo JSON
  fs.readFile('users.json', 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
    const users = JSON.parse(data);
    console.log(users);
    // Verificar si el usuario y contraseña son válidos
    const user = users.find((u) => u.username === username && u.password === password);
    console.log(user);
    if (!user) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }
    const date = Date.now();
    // Generar token JWT
    const token = jwt.sign({ username, date }, SECRET_KEY); // Token expira en 1 hora
    console.log(token);
    // Devolver el token en la respuesta
    res.json({ token });
  });
});

// Nuevo endpoint para devolver los datos del endpoint externo
app.get('/data', verifyToken, async (req, res) => {
  try {
    const response = await axios.get('https://api.npoint.io/9d122573b46e2ac7a185');
    const data = response.data;
    res.json(data);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al obtener los datos del endpoint externo' });
  }
});

// Middleware para verificar el token en las solicitudes protegidas
function verifyToken(req, res, next) {
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(403).json({ error: 'Token de acceso no proporcionado' });
  }

  jwt.verify(token, SECRET_KEY, (err, decoded) => {
    if (err) {
      return res.status(401).json({ error: 'Token de acceso inválido' });
    }
    req.user = decoded;
    next();
  });
}

// Iniciar el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
