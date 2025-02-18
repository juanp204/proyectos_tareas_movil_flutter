import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:login_huella/lobby.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricSetting();
  }

  void _loadBiometricSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Lobby()),
                  );
                },
                child: Text('Login'),
              ),
              _biometricEnabled
                  ? SizedBox(height: 20.0)
                  : Container(), // Espacio adicional si los datos biométricos están habilitados
              _biometricEnabled
                  ? ElevatedButton(
                      onPressed: () async {
                        final LocalAuthentication auth = LocalAuthentication();
                        final List<BiometricType> availableBiometrics =
                            await auth.getAvailableBiometrics();
                        print(availableBiometrics);
                        if (availableBiometrics
                                .contains(BiometricType.strong) ||
                            availableBiometrics
                                .contains(BiometricType.fingerprint)) {
                          final bool didAuthenticate = await auth.authenticate(
                              localizedReason:
                                  'Please authenticate to show account balance',
                              options: const AuthenticationOptions(
                                  biometricOnly: true));
                          if (didAuthenticate) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Lobby()),
                            );
                          }
                        }
                      },
                      child: Text('Iniciar con datos biométricos'),
                    )
                  : Container(), // Botón para iniciar sesión con datos biométricos
            ],
          ),
        ),
      ),
    );
  }
}
