// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/theme/theme_provider.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:pro_graduacion/widget/navigation_drawe.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    ThemeProvider().inicializarTema();
    pageController = PageController(initialPage: 0, viewportFraction: 0.75);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sliderMap = [
      {
        "tittle": "🤌 Rendimiento",
        "price": "10",
        "image": "assets/images/sider1.png"
      },
      {
        "tittle": "💻Integración",
        "price": "10",
        "image": "assets/images/slider2.png"
      },
      {
        "tittle": "📷 Archivos",
        "price": "10",
        "image": "assets/images/slider4.png"
      }
    ];

    Future<String> getLocalPath() async {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }

    String mensaje = "HolaMundo";
    Future<bool> imageExists(String imageName) async {
      final path = await getLocalPath();
      final file = File('$path/$imageName');
      return await file.exists();
    }

    Future<String> checkImage(String pathimage) async {
      bool exists = await imageExists(pathimage);
      String ret = "";
      if (exists) {
        ret = 'La imagen existe en el almacenamiento interno.';
      } else {
        ret = 'La imagen no existe.';
      }
      setState(() {
        mensaje = ret;
      });

      return "1";
    }

    return Scaffold(
      drawer: const NavigationDrawerWidget(),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text("Inicio"),
        centerTitle: true,
        backgroundColor: ccolor2,
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                  itemCount: sliderMap.length,
                  controller: pageController,
                  itemBuilder: (_, index) {
                    return AnimatedBuilder(
                      animation: pageController,
                      builder: (context, child) {
                        return child!;
                      },
                      child: Container(
                        height: 200,
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: primaryColor, style: BorderStyle.solid),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(children: [
                            Image(
                              image: AssetImage(
                                "${sliderMap.elementAt(index)['image']}",
                              ),
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              width: double.infinity,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "${sliderMap.elementAt(index)['tittle']}",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              // color: Colors.amber,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.primaryContainer),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "¡Bienvenido a Genesis!",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Descubre un mundo de posibilidades con nuestra innovadora aplicación de traducción. Captura imágenes y deja que Genesis convierta el texto en un nuevo idioma al instante. Ya sea que estés viajando, estudiando o simplemente explorando, estamos aquí para ayudarte a comunicarte sin barreras.",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SvgPicture.asset(
                      "assets/images/wel1.svg",
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                      height: 260,
                    ),
                    Text(
                      "¡Comienza tu viaje de traducción ahora!",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    // FutureBuilder(
                    //     future: db.getAllUsers(),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.connectionState ==
                    //           ConnectionState.waiting) {
                    //         return const Center(
                    //             child: CircularProgressIndicator());
                    //       } else if (snapshot.hasError) {
                    //         return Center(
                    //             child: Text('Error: ${snapshot.error}'));
                    //       } else if (!snapshot.hasData ||
                    //           snapshot.data!.isEmpty) {
                    //         return const Center(
                    //             child: Text('No hay datos disponibles'));
                    //       }
                    //       final ejemplo = snapshot.data!;
                    //       return ListView.builder(
                    //         shrinkWrap: true,
                    //         itemCount: ejemplo.length,
                    //         itemBuilder: (context, index) {
                    //           return ListTile(
                    //             title: Text(ejemplo[index]["nombres"] +
                    //                 " " +
                    //                 ejemplo[index]["apellidos"] +
                    //                 " " +
                    //                 ejemplo[index]["imagen"]),
                    //           );
                    //         },
                    //       );
                    //     }),
                    ButtonWidget(
                        text: "Iniciar",
                        icon: Icons.emoji_emotions_sharp,
                        onClicked: () {
                          checkImage("1726112306662.png");
                        },
                        color1: ccolor1,
                        color2: ccolor2,
                        isborder: true),
                    // Text(mensaje),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Icon(
          Icons.help,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Builder(
//               builder: (context) => Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.symmetric(horizontal: 32),
//                 child: Column(
//                   children: [
//                     ButtonWidget(
//                       icon: Icons.open_in_new,
//                       text: 'Abrir Menu',
//                       onClicked: () {
//                         Scaffold.of(context).openDrawer();
//                       },
//                       color1: ccolor1,
//                       color2: ccolor2,
//                       isborder: false,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class Pruebasn extends ChangeNotifier {
  String? _imagePath;

  String? get imagePath => _imagePath;

  void updateprueba(String mensaje) {
    _imagePath = mensaje;
    notifyListeners(); // Notifica a los oyentes que el estado ha cambiado
  }
}
