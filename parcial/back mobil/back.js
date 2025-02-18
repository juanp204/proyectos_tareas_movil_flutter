const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');
const jwt = require('jsonwebtoken');
const cors = require('cors');

const app = express();
const port = 8000;

app.use(bodyParser.json());
app.use(cors());


// Conexión a la base de datos MySQL
const db = mysql.createConnection({
    host: 'localhost',
    user: 'mobil',
    password: 'tu_contraseña',
    database: 'mydatabase'
});

db.connect((err) => {
    if (err) {
        throw err;
    }
    console.log('Connected to database');
});

app.post('/auth', (req, res) => {
    const { username, password } = req.body;

    // Verificar el nombre de usuario y la contraseña en la base de datos
    // Modificar la consulta SQL para buscar en la tabla de usuarios
    db.query('SELECT * FROM usuarios WHERE username = ? AND password = ?', [username, password], (err, results) => {
        if (err) {
            res.status(500).send('Error verificando la autenticación');
        } else {
            // Verificar si se encontró un usuario con el nombre de usuario y contraseña proporcionados
            if (results.length > 0) {
                // Si la autenticación es exitosa, generar y devolver un token JWT
                const token = jwt.sign({ username: username }, 'secreto', { expiresIn: '7d' });
                res.json({ 'access': token });
            } else {
                res.status(401).json({ 'error': 'Nombre de usuario o contraseña incorrectos' });
            }
        }
    });
});


// Ruta para obtener los datos
app.get('/articulos', (req, res) => {
    // Aquí deberías verificar el token JWT y realizar la lógica de autenticación si es necesario

    // Supongamos que simplemente devolvemos todos los artículos en la base de datos
    db.query('SELECT * FROM articulos', (err, results) => {
        if (err) {
            res.status(500).send('Error obteniendo los artículos');
        } else {
            res.json(results);
        }
    });
});


// Ruta para obtener los favoritos
app.get('/Favoritos', (req, res) => {
    // Aquí deberías verificar el token JWT y realizar la lógica de autenticación si es necesario

    // Supongamos que simplemente devolvemos todos los artículos marcados como favoritos en la base de datos
    db.query('SELECT * FROM articulos WHERE favorito = true', (err, results) => {
        if (err) {
            res.status(500).send('Error obteniendo los favoritos');
        } else {
            res.json(results);
        }
    });
});

// Ruta para agregar un artículo a favoritos
app.post('/Agregar', (req, res) => {
    // Aquí deberías verificar el token JWT y realizar la lógica de autenticación si es necesario

    const { id } = req.body;

    // Supongamos que simplemente marcamos un artículo como favorito en la base de datos
    db.query('UPDATE articulos SET favorito = true WHERE id = ?', [id], (err, result) => {
        if (err) {
            res.status(500).send('Error marcando el artículo como favorito');
        } else {
            res.status(200).send('Artículo marcado como favorito exitosamente');
        }
    });
});

app.post('/Quitar', (req, res) => {
    // Aquí deberías verificar el token JWT y realizar la lógica de autenticación si es necesario

    const { id } = req.body;

    // Supongamos que simplemente marcamos un artículo como favorito en la base de datos
    db.query('UPDATE articulos SET favorito = 0 WHERE id = ?', [id], (err, result) => {
        if (err) {
            res.status(500).send('Error quitando el artículo como favorito');
        } else {
            res.status(200).send('Artículo quitado como favorito exitosamente');
        }
    });
});


// Iniciar el servidor
app.listen(port, () => {
    console.log(`Servidor en ejecución en http://localhost:${port}`);
});
