// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pro_graduacion/Components/InputFieldPassword.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/Components/inputField.dart';
import 'package:pro_graduacion/model/usuario.dart';
import 'package:pro_graduacion/pages/crearCuenta.dart';
import 'package:pro_graduacion/pages/home.dart';
import 'package:pro_graduacion/widget/alert_widget.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IniciarSesion extends StatefulWidget {
  const IniciarSesion({super.key});

  @override
  State<IniciarSesion> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool islogin = false;
  Usuario us = Usuario();
  // final db = Databasepro();

  inicializarSesion() async {
    var retorno = await us.autenticarUsuario(email.text, password.text);

    if (retorno == 1) {
      AlertaMensaje.showSnackBar(
        context,
        "Usuario Autenticado correctamente!!",
        const Color.fromARGB(255, 85, 230, 217),
      );

      // Esperar un breve momento antes de navegar
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      });
    } else {
      AlertaMensaje.showSnackBar(context, 'Error al autenticarse', errorColor);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  String? validarCorreo(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'El correo electrónico no puede estar vacío.';
    }

    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(valor)) {
      return 'Por favor, ingrese un correo electrónico válido.';
    }

    return null;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 28.0,
                ),
                const Text(
                  "Autenticarse",
                  style: TextStyle(color: primaryColor, fontSize: 40, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 30,
                ),
                SvgPicture.asset(
                  "assets/images/account.svg",
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                  height: 450,
                ),
                InputField(
                  hint: "Correo Electronico",
                  icon: Icons.email,
                  controller: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      AlertaMensaje.showSnackBar(
                          context,
                          "El correo electrónico no puede estar vacío",
                          Colors.orange);
                      return '.';
                    }

                    final regex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!regex.hasMatch(value)) {
                      AlertaMensaje.showSnackBar(
                          context,
                          "Por favor, ingrese un correo electrónico válido.",
                          Colors.orange);
                      return ".";
                    }

                    return null;
                  },
                ),
                InputFieldPass(
                  hint: "Contrasenia",
                  icon: Icons.password,
                  controller: password,
                  passwordInvisible: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonWidget(
                  text: "Ingresar",
                  onClicked: () {
                    if (_formKey.currentState?.validate() == true) {
                      // Procesar datos si son válidos
                      inicializarSesion();
                    } else {
                      AlertaMensaje.showSnackBar(context,
                          "Por favor verificar los datos", secondyColors);
                    }
                  },
                  icon: Icons.login,
                  color1: ccolor1,
                  color2: ccolor2,
                  isborder: false,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No tengo una cuenta.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CrearCuenta(),
                            ),
                          );
                        },
                        child: const Text("Crear Cuenta"))
                  ],
                ),
                islogin
                    ? Text(
                        "Username or password incorrect!!",
                        style: TextStyle(color: Colors.red.shade900),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
