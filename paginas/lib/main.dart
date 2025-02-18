import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Vista1(),
        '/vista2': (context) => const Vista2(),
        '/vista3': (context) => const Vista3(),
      },
    );
  }
}

class Vista1 extends StatelessWidget {
  const Vista1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista 1')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Vista2()),
                );
              },
              child: const Text('Ir a Vista 2 (PUSH)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/vista2');
              },
              child: const Text('Ir a Vista 2 (PUSHNAMED)'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(const Vista3());
              },
              child: const Text('Ir a Vista 3 (GET.TO)'),
            ),
          ],
        ),
      ),
    );
  }
}

class Vista2 extends StatelessWidget {
  const Vista2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista 2')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Regresar a Vista 1'),
        ),
      ),
    );
  }
}

class Vista3 extends StatelessWidget {
  const Vista3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista 3')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Regresar a Vista 1'),
        ),
      ),
    );
  }
}
