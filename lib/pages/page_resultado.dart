import 'package:flutter/material.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/model/resultados.dart';
import 'package:pro_graduacion/pages/IniciarSesion.dart';
import 'package:pro_graduacion/widget/alert_widget.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:pro_graduacion/widget/navigation_drawe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Resultados extends StatefulWidget {
  const Resultados({super.key});

  @override
  State<Resultados> createState() => _ResultadosState();
}

class _ResultadosState extends State<Resultados> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Resultados",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ccolor1,
        centerTitle: true,
      ),
      drawer: const NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 1,
              ),
              GridImage(),
            ],
          ),
        ),
      ),
    );
  }
}

class GridImage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GridImageState();
  }
}

class GridImageState extends State<GridImage> {
  List<Map<String, dynamic>> gridMap = [
    {
      "fechacreacion": "tea",
      "nombreArchivo": "tea",
      "idresultado": "10",
      "imagen":
          "https://cdn.pixabay.com/photo/2023/02/07/14/45/translation-7774314_1280.jpg"
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    _checkSession();
    crearResultados();
    super.initState();
  }

  ResultadosImagen re = ResultadosImagen();

  Future<void> crearResultados() async {
    gridMap.clear();

    int retorno = await re.verResultados();
    print(retorno);
    if (retorno == 1) {
      List<dynamic> items = [];

      items = await re.enviarDatosre();
      setState(() {
        for (var t in items) {
          String imagen = t["imagen"];
          String idresultado = t["idresultado"];
          String nombreArchivo = t["nombreArchivo"];
          String fechacreacion = t["fechacreacion"];
          print(imagen);
          var adde = {
            'imagen': imagen,
            'idresultado': idresultado,
            'nombreArchivo': nombreArchivo,
            'fechacreacion': fechacreacion
          };
          gridMap.add(adde);
        }
      });
    }
  }

  Future<void> _checkSession() async {
    bool exists = await isSessionVariableExists('correovar');

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
  Widget build(BuildContext context) {
    // Obtener el ancho de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    // Calcular el número de columnas basado en el ancho de la pantalla
    int crossAxisCount = screenWidth < 600
        ? 2
        : 3; // 2 columnas en pantallas pequeñas, 3 en grandes

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: gridMap.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 180, // Altura fija para cada item
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _showExpandedImage(context, gridMap[index]['imagen'],
                gridMap[index]['idresultado'], gridMap[index]['nombreArchivo']);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(-2, 1), // changes position of shadow
                ),
              ],
              border: Border.all(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  style: BorderStyle.solid,
                  width: 1),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    "${gridMap[index]['imagen']}",
                    fit: BoxFit.cover,
                    height: 120, // Altura de la imagen
                    width: double.infinity, // Ancho completo
                  ),
                ),
                const SizedBox(height: 8), // Espacio entre imagen y texto
                Text(
                  "Fecha Creación: ${gridMap[index]['fechacreacion']}",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(children: [
  //     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //       Text(
  //         '${gridMap.length} archivos',
  //         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
  //       ),
  //       Row(
  //         children: [
  //           Checkbox(
  //             value: true,
  //             onChanged: (value) {},
  //             activeColor: ccolor2,
  //           ),
  //           const Icon(
  //             Icons.more_vert,
  //             color: ccolor2,
  //           )
  //         ],
  //       ),
  //     ]),
  //     GridView.builder(
  //       physics: const NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       itemCount: gridMap.length,
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         crossAxisSpacing: 12,
  //         mainAxisSpacing: 12,
  //         mainAxisExtent: 200,
  //       ),
  //       itemBuilder: (context, index) {
  //         return GestureDetector(
  //           onTap: () {
  //             _showExpandedImage(context, gridMap.elementAt(index)['imagen']);
  //           },
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.transparent,
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Column(
  //               children: [
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.circular(6),
  //                   child: Image.network(
  //                     "${gridMap.elementAt(index)['imagen']}",
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 Text(
  //                     "Fecha Creacion, ${gridMap.elementAt(index)['fechacreacion']}"),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     )
  //   ]);
  // }

  void _showExpandedImage(BuildContext context, String imageUrl,
      String idresultado, String nombreArchivo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRect(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.network(
                      imageUrl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ButtonWidget(
                      text: "Eliminar",
                      icon: Icons.delete,
                      onClicked: () async {
                        int retorno = await re.eliminarResultadoUser(
                            idresultado, nombreArchivo);
                        print("re");
                        print(retorno);

                        if (retorno == 1) {
                          AlertaMensaje.showSnackBar(
                              // ignore: use_build_context_synchronously
                              context,
                              "Imagen Eliminada Correctamente.",
                              Colors.orange);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          crearResultados();
                          // setState(() {});
                        } else {
                          AlertaMensaje.showSnackBar(
                              // ignore: use_build_context_synchronously
                              context,
                              "Error al intentar eliminar el archivo.",
                              errorColor);
                        }
                      },
                      color1: const Color.fromARGB(255, 255, 0, 81),
                      color2: const Color.fromARGB(255, 76, 0, 0),
                      isborder: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
