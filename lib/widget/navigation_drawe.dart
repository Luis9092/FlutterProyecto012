// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, prefer_const_constructors, unused_field

import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:pro_graduacion/database/databasepro.dart';
import 'package:pro_graduacion/pages/IniciarSesion.dart';
import 'package:pro_graduacion/pages/acerca.dart';
import 'package:pro_graduacion/pages/elegir_archivo.dart';
import 'package:pro_graduacion/pages/tomar_foto.dart';
import 'package:pro_graduacion/pages/user_page.dart';
import 'package:pro_graduacion/theme/theme_provider.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class Counter with ChangeNotifier {
//   bool _count = false;

//   bool get count => _count;

//   Future<void> increment() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _count = prefs.getInt("them") == 1 ? true : false;
//     notifyListeners(); // Notifica a los oyentes sobre el cambio
//   }
// }

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({super.key});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  bool isToggled = false;
  final db = Databasepro();

  void toggleSwitch(bool value) {
    setState(() {
      isToggled = value; // Cambiar el estado del toggle
    });
  }

  final padding = const EdgeInsets.symmetric(horizontal: 24);
  int? _id;
  String _storedValue = '';
  String _nombres12 = '';
  String _apellidos12 = '';
  String _pathImagenProfile = '';
  int? _themeapp;

  Future<void> _loadSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getInt("id");
      _storedValue = prefs.getString('session_variable') ?? 'No hay datos';
      _nombres12 = prefs.getString("nombres12") ?? 'No hay datos';
      _apellidos12 = prefs.getString("apellidos12") ?? 'No hay datos';
      _pathImagenProfile = prefs.getString("ima") ?? 'No hay datos';
      _themeapp = prefs.getInt("them");
    });
  }

// Cerrar sesión
  Future<void> _cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();

    // Eliminar los datos de SharedPreferences
    await prefs.clear();

    // Navegar a la página de inicio de sesión
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const IniciarSesion()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  void _updateSwitchValue(int id, bool value) async {
    await db.actualizarTheme(id, value ? 1 : 0);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("them", value ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    final name = "$_nombres12 $_apellidos12";
    final email = _storedValue;
    final urlImage = _pathImagenProfile;
    return Drawer(
      child: Material(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserPage(
                    name: name,
                    urlImage: urlImage,
                  ),
                ),
              ),
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  // buildSearchField(),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    context: context,
                    text: 'Tomar Foto',
                    icon: Icons.camera,
                    color: const Color.fromARGB(255, 255, 136, 51),
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    context: context,
                    text: 'Elegir Archivo',
                    icon: Icons.collections_sharp,
                    color: const Color.fromARGB(255, 215, 46, 125),
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    context: context,
                    text: 'Resultados',
                    icon: Icons.table_chart,
                    color: const Color.fromARGB(255, 90, 181, 48),
                    onClicked: () => selectedItem(context, 2),
                  ),

                  const SizedBox(height: 16),
                  buildMenuItem(
                    context: context,
                    text: 'Anotaciones',
                    icon: Icons.notes,
                    color: const Color.fromARGB(255, 79, 180, 248),
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    context: context,
                    text: 'Acerca De',
                    icon: Icons.adb_outlined,
                    color: const Color.fromARGB(255, 44, 205, 151),
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(32), // Bordes redondeados

                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .shadow, // Color de la sombra
                          blurRadius: 4.0, // Desenfoque de la sombra
                          spreadRadius: 1.0, // Expansión de la sombra
                          offset:
                              const Offset(0, 2), // Desplazamiento de la sombra
                        ),
                      ],
                    ),
                    child: LiteRollingSwitch(
                      width: 112,
                      value: Provider.of<ThemeProvider>(context, listen: false)
                          .istheme,
                      textOn: "Light",
                      textOff: "Dark",
                      iconOn: Icons.light_mode,
                      iconOff: Icons.dark_mode,
                      textSize: 18,
                      textOnColor: Color.fromRGBO(238, 238, 238, 1),
                      textOffColor: Color.fromRGBO(46, 53, 60, 1),
                      colorOn: Color.fromRGBO(46, 53, 60, 1),
                      colorOff: Color.fromRGBO(238, 238, 238, 1),
                      onChanged: (bool position) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();

                        setState(() {
                          _updateSwitchValue(_id!, position);
                          _loadSessionData();
                        });
                      },
                      onTap: () {},
                      onDoubleTap: () {},
                      onSwipe: () {},
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  ButtonWidget(
                      text: "Salir",
                      icon: Icons.security,
                      onClicked: () {
                        _cerrarSesion();
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(const EdgeInsets.symmetric(vertical: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(radius: 75, backgroundImage: AssetImage(urlImage)),
              const SizedBox(width: 20),

              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                email,
              ),
              // ],
              // ),
              // const Spacer(),
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    required BuildContext context,
    required String text,
    required IconData icon,
    required Color color,
    VoidCallback? onClicked,
  }) {
    const hoverColor = Colors.grey;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer, // Color de fondo del ListTile
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: ListTile(
        leading: Container(
          // alignment: Alignment.center,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: color, // Color de la sombra
                blurRadius: 6, // Desenfoque de la sombra
                // spreadRadius: 1.0, // Expansión de la sombra
              ),
            ],
          ),
          child: Icon(icon),
        ),
        title: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        hoverColor: hoverColor,
        onTap: onClicked,
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      // TOMAR FOTO
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const TomarFoto(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ElegirArchivo(),
        ));
        break;

      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AcercaDe(),
        ));
        break;
    }
  }
}
