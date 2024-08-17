// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pro_graduacion/Components/InputFieldPassword.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/Components/inputField.dart';
import 'package:pro_graduacion/database/databasepro.dart';
import 'package:pro_graduacion/json/usuario.dart';
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

  final db = Databasepro();

  inicializarSesion() async {
    var retorno = await db.autenticarUsuario(
      Usuario.construye(
          correo: email.text,
          contrasenia: password.text,
          estado: 0,
          theme: 0,
          fechaNaciminiento: "",
          fechaCreacion: ""),
    );
    if (retorno == true) {
      if (!mounted) return;
      Usuario? usrDetails = await db.getUsers(email.text);
      _saveSessionData(usrDetails?.idUsuario, email.text, usrDetails?.nombres,
          usrDetails?.apellidos, usrDetails?.imagen, usrDetails?.theme);

      AlertaMensaje.showSnackBar(
          context, "Verificacion exitosa :)", primaryColor);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } else {
      setState(() {
        islogin = true;
      });
      AlertaMensaje.showSnackBar(
          context, "Contrasenia o usuario incorrecto!!", errorColor);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  // Cargar datos de sesión
  Future<void> _loadSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.getString('session_variable') ?? '';
      prefs.getInt('id') ?? 0;
      prefs.getString('nombres12') ?? '';
      prefs.getString('apellidos12') ?? '';
      prefs.getString('ima') ?? '';
      prefs.getInt('them') ?? 0;
    });
  }

  // Guardar datos de sesión
  Future<void> _saveSessionData(int? id, String correo, String? nombres,
      String? apellidos, String? imagen, int? them) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('id', id!);
    await prefs.setString('session_variable', correo);
    await prefs.setString('nombres12', nombres!);
    await prefs.setString('apellidos12', apellidos!);
    await prefs.setString('ima', imagen!);
    await prefs.setInt('them', them!);

    _loadSessionData(); // Cargar el nuevo valor
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
        child: Center(
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
                    style: TextStyle(color: primaryColor, fontSize: 40),
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
                      // if (_formKey.currentState?.validate() ?? false) {
                      if (_formKey.currentState?.validate() == true) {
                        // Procesar datos si son válidos
                        inicializarSesion();
                      } else {
                        AlertaMensaje.showSnackBar(context,
                            "Por favor verificar los datos", secondyColors);
                      }
                    },
                    icon: Icons.login,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No tengo una cuenta",
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
      ),
    );
  }
}
