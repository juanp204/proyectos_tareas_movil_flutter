import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final storage = FlutterSecureStorage();
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}/usuarios'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // Implement your message handling logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await storage.delete(key: 'token');
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: users.isEmpty
          ? Center(child: Text('No hay usuarios disponibles'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetail(user: user),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Image.network('http://${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}/perfil/${user['email']}'),
                    title: Text(user['fullName']),
                    subtitle: Text(user['email']),
                    trailing: Text(user['role']),
                  ),
                );
              },
            ),
    );
  }
}

class UserDetail extends StatelessWidget {
  final dynamic user;

  const UserDetail({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(user['fullName']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network('http://${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}/perfil/${user['email']}'),
            ),
            SizedBox(height: 16),
            Text('Email: ${user['email']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Nombre Completo: ${user['fullName']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Teléfono: ${user['phoneNumber']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Rol: ${user['role']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Mensaje',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String message = messageController.text;
                String recipientEmail = user['email'];

                if (message.isNotEmpty) {
                  String url = 'http://${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}/send-message';
                  Map<String, String> headers = {"Content-Type": "application/json"};
                  Map<String, dynamic> body = {
                    "recipientEmail": recipientEmail,
                    "message": message
                  };

                  try {
                    var response = await http.post(
                      Uri.parse(url),
                      headers: headers,
                      body: jsonEncode(body),
                    );

                    if (response.statusCode == 200) {
                      var jsonResponse = jsonDecode(response.body);
                      if (jsonResponse['success']) {
                        print('Mensaje enviado con éxito');
                      } else {
                        print('Error al enviar mensaje: ${jsonResponse['error']}');
                      }
                    } else {
                      print('Error al enviar mensaje: ${response.reasonPhrase}');
                    }
                  } catch (e) {
                    print('Error al enviar mensaje: $e');
                  }
                } else {
                  print('El mensaje no puede estar vacío');
                }
              },
              child: Text('Enviar Mensaje'),
            ),
          ],
        ),
      ),
    );
  }
}