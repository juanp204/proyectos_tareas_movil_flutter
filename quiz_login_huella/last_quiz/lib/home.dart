import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;

class HomePageHuella extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageHuella> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isHuellaEnabled = false;
  bool _isHuellaAvailable = false;
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late final Future<String?> token = storage.read(key: "token");

  @override
  void initState() {
    super.initState();
    _loadHuellaEnabled();
    _checkHuellaAvailability();
  }

  _checkHuellaAvailability() async {
    bool isAvailable = await auth.canCheckBiometrics;
    setState(() {
      _isHuellaAvailable = isAvailable;
    });
  }

  _loadHuellaEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isHuellaEnabled = prefs.getBool('huellaEnabled') ?? false;
    });
  }

  _saveHuellaEnabled(bool isHuellaEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('huellaEnabled', isHuellaEnabled);
  }

  enableHuella(String username, String password) async {
    // Call API to enable fingerprint login
    final String? fetchedToken = await token;
    if (fetchedToken == null || fetchedToken.isEmpty) {
      throw Exception('Token is null or empty');
    }
    print(username + password);
    var bodyString = 'username=$username&password=$password';
    var response = await http.post(
      Uri.parse('http://192.168.176.2:3000/habilitarhuella'),
      body: bodyString,
      headers: {
        'Authorization': fetchedToken,
      },
    );

    if (response.statusCode == 200) {
      // Save token to secure storage
      await storage.write(key: 'huella', value: response.body);
      // Update UI and preferences
      setState(() {
        _isHuellaEnabled = true;
      });
      _saveHuellaEnabled(true);
      Navigator.pop(context); // Cerrar el modal bottom sheet
    } else {
      // Handle error

      setState(() {
        _isHuellaEnabled = true;
      });
      _saveHuellaEnabled(true);
      Navigator.pop(context);

      print('Error enabling fingerprint login: ${response.body}');
      // Muestra un snackbar para informar al usuario sobre el error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Error habilitando la autenticación de huellas dactilares'),
        backgroundColor: Colors.red,
      ));
    }
  }

  _disableHuella() async {
    // Delete token from secure storage
    await storage.delete(key: 'huella');
    // Update UI and preferences
    setState(() {
      _isHuellaEnabled = false;
    });
    _saveHuellaEnabled(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista habilitar huella'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Habilitar inicio de sesión con huella.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (_isHuellaEnabled) {
                  _disableHuella();
                } else {
                  bool authenticated = await auth.authenticate(
                      localizedReason:
                          'Please authenticate to enable fingerprint login');

                  if (authenticated) {
                    //authenticated
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Ingrese su nombre de usuario y contraseña',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                TextFormField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                      labelText: 'Nombre de usuario'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese su nombre de usuario';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration:
                                      InputDecoration(labelText: 'Contraseña'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese su contraseña';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          enableHuella(
                                            _usernameController.text,
                                            _passwordController.text,
                                          );
                                        }
                                      },
                                      child: Text('Aceptar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Título del diálogo'),
                          content: Text('Contenido del diálogo'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: Text(_isHuellaEnabled ? 'Deshabilitar' : 'Habilitar'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isHuellaEnabled ? Colors.orange : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
