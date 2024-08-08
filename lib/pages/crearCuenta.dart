import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/Components/inputField.dart';
import 'package:pro_graduacion/database/database_helper.dart';
import 'package:pro_graduacion/json/users.dart';
import 'package:pro_graduacion/pages/IniciarSesion.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
// import 'package:pro_graduacion/Components/textField.dart';
// import 'package:pro_graduacion/JSON/users.dart';
// import 'package:pro_graduacion/SQlite/database_helper.dart';
// import 'package:pro_graduacion/Views/login.dart';

class CrearCuenta extends StatefulWidget {
  const CrearCuenta({super.key});

  @override
  State<CrearCuenta> createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuenta> {
  final name = TextEditingController();
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final db = DatabaseHelper();

  sigUp() async {
    var retorno = await db.createUser(Users(
        fullName: name.text,
        email: email.text,
        username: username.text,
        usrPassword: password.text));

    if (retorno > 0) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const IniciarSesion(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 46),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 238, 202),
                  Color.fromARGB(255, 138, 255, 230),
                  Color.fromARGB(255, 255, 255, 255)
                ],
                begin: Alignment.bottomRight,
                transform: GradientRotation(50),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow, // Color de la sombra
                  blurRadius: 1.0, // Desenfoque de la sombra
                  spreadRadius: 1.0, // Expansión de la sombra
                  offset: const Offset(-1, 2), // Desplazamiento de la sombra
                ),
              ],
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: Theme.of(context).colorScheme.background),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //  crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Registrarse",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 55,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                InputField(
                    hint: "Ingresar Nombre",
                    icon: Icons.person,
                    controller: name,
                    passwordInvisible: false),
                InputField(
                    hint: "Ingresar Correo",
                    icon: Icons.person,
                    controller: email,
                    passwordInvisible: false),
                InputField(
                    hint: "Ingresar Username",
                    icon: Icons.people,
                    controller: username,
                    passwordInvisible: false),
                InputField(
                    hint: "Ingresar Password",
                    icon: Icons.password,
                    controller: password,
                    passwordInvisible: true),
                InputField(
                    hint: "Ingresar Confimar Password",
                    icon: Icons.password,
                    controller: confirmPassword,
                    passwordInvisible: true),
                const SizedBox(
                  height: 36,
                ),
                ButtonWidget(
                  text: "Registrarse",
                  onClicked: () {
                    sigUp();
                  },
                  icon: Icons.people,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IniciarSesion(),
                          ),
                        );
                      },
                      child: Text(
                        "Ya tienes una cuenta?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
