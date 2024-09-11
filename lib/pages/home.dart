// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/theme/theme_provider.dart';
// import 'package:pro_graduacion/pages/IniciarSesion.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:pro_graduacion/widget/navigation_drawe.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Función para comprobar la existencia de una variable de sesión
  @override
  void initState() {
    super.initState();
    ThemeProvider().inicializarTema();
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: ccolor2,
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) => Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    ButtonWidget(
                      icon: Icons.open_in_new,
                      text: 'Abrir Menu',
                      onClicked: () {
                        Scaffold.of(context).openDrawer();
                      },
                      color1: ccolor1,
                      color2: ccolor2,
                      isborder: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
