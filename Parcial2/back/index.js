const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
const admin = require('firebase-admin');
const serviceAccount = require('./firebaseConfig.json');

const app = express();
const PORT = 3000;
const SECRET_KEY = 'your_secret_key';

app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'public/');
  },
  filename: (req, file, cb) => {
    const email = req.body.email;
    cb(null, email);
  },
});
const upload = multer({ storage: storage });

app.use(express.static('public'));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

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

app.post('/login', (req, res) => {
  const { username, password, fcmToken } = req.body;

  fs.readFile('users.json', 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
    const users = JSON.parse(data);
    const user = users.find((u) => u.email === username && u.password === password);
    if (!user) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    if (!user.fcmTokens.includes(fcmToken)) {
      user.fcmTokens.push(fcmToken);
      registerFcmTokenToFirebase(user.email, fcmToken).catch(console.error);
    }

    fs.writeFile('users.json', JSON.stringify(users, null, 2), (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Error interno del servidor' });
      }
      const date = Date.now();
      const token = jwt.sign({ username, date }, SECRET_KEY, { expiresIn: '1h' });
      res.json({ token });
 });
});
});
function registerFcmTokenToFirebase(userId, fcmToken) {
  const db = admin.firestore();
  const userRef = db.collection('users').doc(userId);

  return userRef.update({
    fcmTokens: admin.firestore.FieldValue.arrayUnion(fcmToken)
  }).catch(error => {
    console.error('Error al registrar el token FCM en Firebase:', error);
  });
}
app.post('/register', upload.single('photo'), (req, res) => {
  const { email, password, fullName, phoneNumber, role, fcmToken } = req.body;

  if (!email || !password || !fullName || !phoneNumber || !role || !fcmToken) {
    return res.status(400).json({ error: 'Todos los campos son obligatorios' });
  }

  fs.readFile('users.json', 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
    const users = JSON.parse(data);
    const existingUser = users.find((u) => u.email === email);

    if (existingUser) {
      return res.status(409).json({ error: 'El usuario ya existe' });
    }

    const newUser = {
      email,
      password,
      fullName,
      phoneNumber,
      role,
      fcmTokens: [fcmToken],
      photo: req.file.filename
    };

    users.push(newUser);

    fs.writeFile('users.json', JSON.stringify(users, null, 2), (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Error interno del servidor' });
      }
      const date = Date.now();
      const token = jwt.sign({ email, role, date }, SECRET_KEY, { expiresIn: '1h' });
      res.json({ token });
    });
  });
});

app.get('/usuarios', (req, res) => {
  fs.readFile('users.json', 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
    const users = JSON.parse(data);
    res.json(users);
  });
});

app.get('/perfil/:email', (req, res) => {
  const { email } = req.params;

  fs.readFile('users.json', 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
    const users = JSON.parse(data);
    const user = users.find((u) => u.email === email);

    if (!user) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    const filePath = path.join(__dirname, 'public', email);
    res.sendFile(filePath);
  });
});

app.post('/send-message', (req, res) => {
  const { recipientEmail, message } = req.body;

  fs.readFile('users.json', 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
    const users = JSON.parse(data);
    const recipient = users.find((u) => u.email === recipientEmail);

    if (!recipient) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    const messagePayload = {
      notification: {
        title: `${recipientEmail}`,
        body: message,
      },
      tokens: recipient.fcmTokens,
    };

    admin.messaging().sendMulticast(messagePayload)
      .then((response) => {
        console.log(response.successCount + ' mensajes enviados con éxito');
        fs.writeFile('message.json', JSON.stringify(messagePayload, null, 2), (err) => {
          if (err) {
            console.error('Error al guardar el mensaje:', err);
            return res.status(500).json({ error: 'Error al guardar el mensaje' });
          }
          res.json({ success: true });
        });
      })
      .catch((error) => {
        console.error('Error al enviar mensaje:', error);
        res.status(500).json({ error: 'Error al enviar mensaje' });
      });
  });
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});