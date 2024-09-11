import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/pages/IniciarSesion.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:pro_graduacion/widget/navigation_drawe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TomarFoto extends StatelessWidget {
  const TomarFoto({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: const Text('Tomar Foto'),
          centerTitle: true,
          backgroundColor: ccolor2,
        ),
        drawer: const NavigationDrawerWidget(),
        body: const Init(),
      );
}

class Init extends StatefulWidget {
  const Init({super.key});

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {
  XFile? photo;

  Future getImageFromCamera() async {
    photo = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future<void> _checkSession() async {
    bool exists = await isSessionVariableExists('session_variable');

    setState(() {
      exists;
      if (!exists) {
        // Redirigir a la pantalla de inicio de sesión
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IniciarSesion()),
        );
      }
    });
  }

  // Función para comprobar la existencia de una variable de sesión
  Future<bool> isSessionVariableExists(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  @override
  void initState() {
    _checkSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWidget(
                  text: "Camara",
                  icon: Icons.camera,
                  onClicked: () {
                    getImageFromCamera();
                  },
                  color1: ccolor1,
                  color2: ccolor2,
                  isborder: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                photo == null
                    ? const Icon(Icons.image)
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          color: Theme.of(context).colorScheme.background,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.shadow,
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(
                                  -1, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Image.file(
                              File(photo!.path),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                photo != null
                    ? ButtonWidget(
                        text: "Iniciar Scan",
                        icon: Icons.file_present,
                        onClicked: () {},
                        color1: ccolor1,
                        color2: ccolor2,
                        isborder: false,
                      )
                    : const SizedBox(
                        height: 10,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
