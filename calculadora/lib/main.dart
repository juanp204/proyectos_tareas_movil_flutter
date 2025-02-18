import 'package:flutter/material.dart';
import 'package:calculadora/mi_boton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'calculadora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 93, 0, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculadora'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String resultado = "0";
  String operacion = "";
  double num1 = 0;
  double num2 = 0;

  void agregarNumero(String numero) {
    if (resultado == "0") {
      resultado = numero;
    } else {
      resultado += numero;
    }
    setState(() {});
  }

  void agregarOperacion(String operacion) {
    num1 = double.parse(resultado);
    this.operacion = operacion;
    resultado = "0";
    setState(() {});
  }

  void realizarOperacion() {
    num2 = double.parse(resultado);
    if (operacion == "+") {
      resultado = (num1 + num2).toString();
    } else if (operacion == "-") {
      resultado = (num1 - num2).toString();
    } else if (operacion == "X") {
      resultado = (num1 * num2).toString();
    } else if (operacion == "÷") {
      if (num2 != 0) {
        resultado = (num1 / num2).toString();
      } else {
        resultado = "Error";
      }
    } else if (operacion == "%") {
      resultado = (num1 % num2).toString();
    }
    operacion = "";
    setState(() {});
  }

  void borrarUltimoNumero() {
    if (resultado.length > 1) {
      resultado = resultado.substring(0, resultado.length - 1);
    } else {
      resultado = "0";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[200],
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  resultado,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 50.0),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MiBoton(
                    texto: "AC",
                    accionBoton: () => setState(() => resultado = "0")),
                MiBoton(texto: "CE", accionBoton: borrarUltimoNumero),
                MiBoton(texto: "%", accionBoton: () => agregarOperacion("%")),
                MiBoton(texto: "÷", accionBoton: () => agregarOperacion("÷")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MiBoton(texto: "7", accionBoton: () => agregarNumero("7")),
                MiBoton(texto: "8", accionBoton: () => agregarNumero("8")),
                MiBoton(texto: "9", accionBoton: () => agregarNumero("9")),
                MiBoton(texto: "X", accionBoton: () => agregarOperacion("X")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MiBoton(texto: "4", accionBoton: () => agregarNumero("4")),
                MiBoton(texto: "5", accionBoton: () => agregarNumero("5")),
                MiBoton(texto: "6", accionBoton: () => agregarNumero("6")),
                MiBoton(texto: "-", accionBoton: () => agregarOperacion("-")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        MiBoton(
                            texto: "1", accionBoton: () => agregarNumero("1")),
                        MiBoton(
                            texto: "2", accionBoton: () => agregarNumero("2")),
                        MiBoton(
                            texto: "3", accionBoton: () => agregarNumero("3")),
                      ],
                    ),
                    Row(
                      children: [
                        MiBoton(
                            texto: "0", accionBoton: () => agregarNumero("0")),
                        MiBoton(
                            texto: ".", accionBoton: () => agregarNumero(".")),
                        MiBoton(texto: "=", accionBoton: realizarOperacion),
                      ],
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                MiBoton(texto: "+", accionBoton: () => agregarOperacion("+")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
