// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/Components/inputField.dart';
import 'package:pro_graduacion/database/database_helper.dart';
import 'package:pro_graduacion/json/users.dart';
import 'package:pro_graduacion/pages/crearCuenta.dart';
import 'package:pro_graduacion/pages/home.dart';
import 'package:pro_graduacion/widget/button_widget.dart';

class IniciarSesion extends StatefulWidget {
  const IniciarSesion({super.key});

  @override
  State<IniciarSesion> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  final userName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool ischecked = false;
  bool islogin = false;
  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
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
                  passwordInvisible: false,
                ),
                InputField(
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
                  onClicked: () async {
                    // Users? usrDetails = await db.getUser(userName.text);
                    var retorno = await db.autenticar(Users(
                        username: userName.text, usrPassword: password.text));
                    if (retorno == true) {
                      if (!mounted) return;
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                      );
                    } else {
                      setState(() {
                        islogin = true;
                      });
                    }
                  },
                  icon: Icons.present_to_all,
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
    );
  }
}
