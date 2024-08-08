import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:pro_graduacion/pages/acerca.dart';
import 'package:pro_graduacion/pages/elegir_archivo.dart';
import 'package:pro_graduacion/pages/tomar_foto.dart';
import 'package:pro_graduacion/pages/user_page.dart';
import 'package:pro_graduacion/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({super.key});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  bool isToggled = false;


  // void toggleSwitch(bool value) {
  //   setState(() {
  //     isToggled = value; // Cambiar el estado del toggle
  //     print(isToggled);
  //   });
  // }

  final padding = const EdgeInsets.symmetric(horizontal: 24);

  @override
  Widget build(BuildContext context) {
    const name = 'Arbustito Cipress';
    const email = 'arbusto123_69@gmail.com';
    const urlImage = "assets/images/arb.png";
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
                  builder: (context) => const UserPage(
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
                  Text(isToggled.toString()),
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
                      value: false,
                      textOn: "Light",
                      textOff: "Dark",
                      iconOn: Icons.light_mode,
                      iconOff: Icons.dark_mode,
                      textSize: 18,
                      textOnColor: const Color.fromRGBO(238, 238, 238, 1),
                      textOffColor: const Color.fromRGBO(46, 53, 60, 1),
                      colorOn: const Color.fromRGBO(46, 53, 60, 1),
                      colorOff: const Color.fromRGBO(238, 238, 238, 1),
                      onChanged: (bool position) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                        
                             
                      },
                      onTap: () {
                      
                      },
                      onDoubleTap: () {},
                      onSwipe: () {},
                    ),
                  ),
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
              CircleAvatar(radius: 62, backgroundImage: AssetImage(urlImage)),
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
        // gradient: LinearGradient(
        //   begin: Alignment.topRight,
        //   end: Alignment.bottomRight,
        //   stops: const [0.0, 0.95, 0.0],
        //   colors: [
        //     const Color.fromARGB(255, 67, 251, 220),
        //     Theme.of(context).colorScheme.background,
        //     const Color.fromARGB(255, 2, 197, 174)
        //   ],
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).colorScheme.shadow, // Color de la sombra
        //     blurRadius: 4.0, // Desenfoque de la sombra
        //     spreadRadius: 2.0, // Expansión de la sombra
        //     offset: const Offset(-1, 2), // Desplazamiento de la sombra
        //   ),
        // ],
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


 
//   }
// }

// class NavigationDrawerWidget extends StatelessWidget {
//   final padding = const EdgeInsets.symmetric(horizontal: 24);
//   // backgroundColor: Theme.of(context).colorScheme.background,
//   const NavigationDrawerWidget({super.key});



//   @override
//   Widget build(BuildContext context) {
//     const name = 'Arbustito Cipress';
//     const email = 'arbusto123_69@gmail.com';
//     const urlImage = "assets/images/arb.png";
  
//     return Drawer(
//       child: Material(
//         color: Theme.of(context).colorScheme.background,
//         child: ListView(
//           children: <Widget>[
//             buildHeader(
//               urlImage: urlImage,
//               name: name,
//               email: email,
//               onClicked: () => Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => const UserPage(
//                     name: name,
//                     urlImage: urlImage,
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               padding: padding,
//               child: Column(
//                 children: [
//                   // buildSearchField(),
//                   const SizedBox(height: 24),
//                   buildMenuItem(
//                     context: context,
//                     text: 'Tomar Foto',
//                     icon: Icons.camera,
//                     color: const Color.fromARGB(255, 255, 136, 51),
//                     onClicked: () => selectedItem(context, 0),
//                   ),
//                   const SizedBox(height: 16),
//                   buildMenuItem(
//                     context: context,
//                     text: 'Elegir Archivo',
//                     icon: Icons.collections_sharp,
//                     color: const Color.fromARGB(255, 215, 46, 125),
//                     onClicked: () => selectedItem(context, 1),
//                   ),
//                   const SizedBox(height: 16),
//                   buildMenuItem(
//                     context: context,
//                     text: 'Resultados',
//                     icon: Icons.table_chart,
//                     color: const Color.fromARGB(255, 90, 181, 48),
//                     onClicked: () => selectedItem(context, 2),
//                   ),

//                   const SizedBox(height: 16),
//                   buildMenuItem(
//                     context: context,
//                     text: 'Anotaciones',
//                     icon: Icons.notes,
//                     color: const Color.fromARGB(255, 79, 180, 248),
//                     onClicked: () => selectedItem(context, 3),
//                   ),
//                   const SizedBox(height: 24),
//                   const Divider(color: Colors.grey),
//                   const SizedBox(height: 24),
//                   buildMenuItem(
//                     context: context,
//                     text: 'Acerca De',
//                     icon: Icons.adb_outlined,
//                     color: const Color.fromARGB(255, 44, 205, 151),
//                     onClicked: () => selectedItem(context, 4),
//                   ),
//                   const SizedBox(
//                     height: 36,
//                   ),

//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius:
//                           BorderRadius.circular(32), // Bordes redondeados

//                       boxShadow: [
//                         BoxShadow(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .shadow, // Color de la sombra
//                           blurRadius: 4.0, // Desenfoque de la sombra
//                           spreadRadius: 1.0, // Expansión de la sombra
//                           offset:
//                               const Offset(0, 2), // Desplazamiento de la sombra
//                         ),
//                       ],
//                     ),
//                     child: LiteRollingSwitch(
//                       value:  ThemeProvider().themeData == lightMode ? false : true,
//                       textOn: "Light",
//                       textOff: "Dark",
//                       iconOn: Icons.light_mode,
//                       iconOff: Icons.dark_mode,
//                       textSize: 18,
//                       textOnColor: const Color.fromRGBO(238, 238, 238, 1),
//                       textOffColor: const Color.fromRGBO(46, 53, 60, 1),
//                       colorOn: const Color.fromRGBO(46, 53, 60, 1),
//                       colorOff: const Color.fromRGBO(238, 238, 238, 1),
//                       onChanged: (bool position) {
//                         Provider.of<ThemeProvider>(context, listen: false)
//                             .toggleTheme();
//                       },
//                       onTap: () {},
//                       onDoubleTap: () {},
//                       onSwipe: () {},
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildHeader({
//     required String urlImage,
//     required String name,
//     required String email,
//     required VoidCallback onClicked,
//   }) =>
//       InkWell(
//         onTap: onClicked,
//         child: Container(
//           padding: padding.add(const EdgeInsets.symmetric(vertical: 20)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CircleAvatar(radius: 62, backgroundImage: AssetImage(urlImage)),
//               const SizedBox(width: 20),

//               Text(
//                 name,
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 email,
//               ),
//               // ],
//               // ),
//               // const Spacer(),
//             ],
//           ),
//         ),
//       );

//   Widget buildMenuItem({
//     required BuildContext context,
//     required String text,
//     required IconData icon,
//     required Color color,
//     VoidCallback? onClicked,
//   }) {
//     const hoverColor = Colors.grey;

//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context)
//             .colorScheme
//             .primaryContainer, // Color de fondo del ListTile
//         borderRadius: BorderRadius.circular(12.0),
//         border: Border.all(color: Theme.of(context).colorScheme.outline),
//         // gradient: LinearGradient(
//         //   begin: Alignment.topRight,
//         //   end: Alignment.bottomRight,
//         //   stops: const [0.0, 0.95, 0.0],
//         //   colors: [
//         //     const Color.fromARGB(255, 67, 251, 220),
//         //     Theme.of(context).colorScheme.background,
//         //     const Color.fromARGB(255, 2, 197, 174)
//         //   ],
//         // ),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Theme.of(context).colorScheme.shadow, // Color de la sombra
//         //     blurRadius: 4.0, // Desenfoque de la sombra
//         //     spreadRadius: 2.0, // Expansión de la sombra
//         //     offset: const Offset(-1, 2), // Desplazamiento de la sombra
//         //   ),
//         // ],
//       ),
//       child: ListTile(
//         leading: Container(
//           // alignment: Alignment.center,
//           padding: const EdgeInsets.all(5),
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(4),
//             boxShadow: [
//               BoxShadow(
//                 color: color, // Color de la sombra
//                 blurRadius: 6, // Desenfoque de la sombra
//                 // spreadRadius: 1.0, // Expansión de la sombra
//               ),
//             ],
//           ),
//           child: Icon(icon),
//         ),
//         title: Text(
//           text,
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//         hoverColor: hoverColor,
//         onTap: onClicked,
//       ),
//     );
//   }

//   void selectedItem(BuildContext context, int index) {
//     Navigator.of(context).pop();

//     switch (index) {
//       // TOMAR FOTO
//       case 0:
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => const TomarFoto(),
//         ));
//         break;
//       case 1:
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => const ElegirArchivo(),
//         ));
//         break;

//       case 4:
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => const AcercaDe(),
//         ));
//         break;
//     }
//   }
// }



//   // Widget buildSearchField() {
//   //   const color = Colors.white;

//   //   return TextField(
//   //     style: const TextStyle(color: color),
//   //     decoration: InputDecoration(
//   //       contentPadding:
//   //           const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//   //       hintText: 'Search',
//   //       hintStyle: const TextStyle(color: color),
//   //       prefixIcon: const Icon(Icons.search, color: color),
//   //       filled: true,
//   //       fillColor: Colors.white12,
//   //       enabledBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(5),
//   //         borderSide: BorderSide(color: color.withOpacity(0.7)),
//   //       ),
//   //       focusedBorder: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(5),
//   //         borderSide: BorderSide(color: color.withOpacity(0.7)),
//   //       ),
//   //     ),
//   //   );
//   // }