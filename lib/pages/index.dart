import 'package:flutter/material.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/pages/IniciarSesion.dart';
import 'package:pro_graduacion/pages/crearCuenta.dart';
import 'package:pro_graduacion/widget/button_widget.dart';

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "G",
                        style: TextStyle(
                            fontSize: 50,
                            color: primaryColor,
                            decoration: TextDecoration.overline,
                            decorationColor: primaryColor,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "enesis ",
                        style: TextStyle(
                            fontSize: 45, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "I",
                        style: TextStyle(
                            fontSize: 45,
                            color: primaryColor,
                            decoration: TextDecoration.overline,
                            decorationColor: primaryColor,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "mage",
                        style: TextStyle(
                            fontSize: 45, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "T",
                        style: TextStyle(
                            fontSize: 50,
                            color: primaryColor,
                            decoration: TextDecoration.overline,
                            decorationColor: primaryColor,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "ranslator",
                        style: TextStyle(
                            fontSize: 45, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Autenticacion",
                    style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  const Text(
                    "Bienvenido a la app :)",
                    style: TextStyle(color: Color.fromARGB(255, 60, 60, 60)),
                  ),
                  Image.asset("assets/images/fun1.png"),
                  ButtonWidget(
                    text: "Iniciar Sesion",
                    icon: Icons.login,
                    onClicked: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IniciarSesion(),
                        ),
                      );
                    },
                  ),
                  ButtonWidget(
                    text: "Registrarse",
                    icon: Icons.login,
                    onClicked: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CrearCuenta(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text("Version 1.0")
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.help,
          ),
      ),
    );
  }
}



// AGREGAR BOTTON PARA VER CONTRASNIA
// FORMAR TABLA PARA LOGUEARSE, QUE SEA ESCALABLE


//VER EL BOTON DE THEME 