import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Laboratorio 8 GPS'),
        ),
        body: LocationWidget(),
      ),
    );
  }
}

class LocationWidget extends StatefulWidget {
  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String _location = 'Ubicación Desconocida';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_location),
          ElevatedButton(
            onPressed: _getCurrentLocation,
            child: Text('Obtener ubicación'),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    final position = await _obtenerGps();
    final googleMapsUrl = "http://www.google.com/maps/place/${position.latitude},${position.longitude}";
    setState(() {
      _location = googleMapsUrl;
    });
    _abrirUrl(googleMapsUrl);
  }

  Future<Position> _obtenerGps() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      return Future.error('Habilite los servicios de ubicación.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Se deniegan los permisos de ubicación.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Los permisos de ubicación están permanentemente denegados, no podemos solicitar permisos.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _abrirUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo iniciar $url';
    }
  }
}