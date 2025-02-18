import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  String _selectedRole = 'User'; // Nuevo estado para el rol seleccionado
  File? _photo;

  Future<void> register() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://${dotenv.env['DOMAIN']}:${dotenv.env['PORT']}/register'));
    request.fields['email'] = _emailController.text;
    request.fields['password'] = _passwordController.text;
    request.fields['fullName'] = _fullNameController.text;
    request.fields['phoneNumber'] = _phoneNumberController.text;
    request.fields['role'] = _selectedRole;
    request.fields['fcmToken'] = fCMToken ?? " ";

    if (_photo != null) {
      request.files
          .add(await http.MultipartFile.fromPath('photo', _photo!.path));
    }

    var response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = json.decode(responseBody);
      await storage.write(key: 'token', value: decodedResponse['token']);
      print('Registered and token saved!');
    } else {
      print('Registration failed!');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView( child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value.toString();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your role';
                  }
                  return null;
                },
                items: [
                  DropdownMenuItem(
                    value: 'Admin',
                    child: Text('Admin'),
                  ),
                  DropdownMenuItem(
                    value: 'User',
                    child: Text('User'),
                  ),
                  DropdownMenuItem(
                    value: 'Moderator',
                    child: Text('Moderator'),
                  ),
                  // Agrega más roles según tu necesidad
                ],
                decoration: InputDecoration(labelText: 'Role'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    register();
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: Text('Register'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/login'); // Navigate to the registration screen
                },
                child: Text("Already registered?, click here to Login."),
              ),
            ],
          ),
        ),
      ),),
    );
  }
}
