import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static String domain = "192.168.195.1";
  final LocalAuthentication auth = LocalAuthentication();
  bool _isHuellaAvailable = false;
  bool _isHuellaEnabled = false;
  String _username = '';
  String _password = '';
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkHuellaAvailability();
    _loadHuellaEnabled();
  }

  _loadHuellaEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isHuellaEnabled = prefs.getBool('isHuellaEnabled') ?? false;
    });
  }

  _checkHuellaAvailability() async {
    bool isAvailable = await auth.canCheckBiometrics;
    setState(() {
      _isHuellaAvailable = isAvailable;
    });
  }

  _saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  _loginWithCredentials() async {
    print("credenciales");

    print(_username + _password);

    var response = await http.post(
      Uri.parse('http://$domain:3000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _username,
        'password': _password,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      _saveToken(data['token']);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Handle error
    }
  }

  _loginWithHuella() async {
    bool authenticated =
        await auth.authenticate(localizedReason: 'Login with fingerprint');

    if (authenticated) {
      String? huellaToken = await storage.read(key: 'huella');
      var response = await http.post(
        Uri.parse('http://$domain:3000/loginhuella'),
        body: json.encode({
          'token': huellaToken,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _saveToken(data['token']);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with biometrics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
              ),
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _loginWithCredentials,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            if (_isHuellaAvailable & _isHuellaEnabled)
              ElevatedButton(
                onPressed: _loginWithHuella,
                child: Text('Login with fingerprint'),
              ),
          ],
        ),
      ),
    );
  }
}
