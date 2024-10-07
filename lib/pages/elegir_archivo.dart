import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/model/imagen.dart';
import 'package:pro_graduacion/pages/IniciarSesion.dart';
import 'package:pro_graduacion/widget/alert_widget.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:pro_graduacion/widget/navigation_drawe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElegirArchivo extends StatelessWidget {
  const ElegirArchivo({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Escaneando Archivos'),
          centerTitle: true,
          backgroundColor: ccolor1,
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
  File? _imageFile;
  String? _imageName;
  Imagen imagen = Imagen();
  List<DropdownMenuItem<String>> itemsFinal = [];

  Future getImageFromGallery() async {
    photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (photo != null) {
        cambiarNombreImagen();
      }
    });
  }

  Future<int> cambiarNombreImagen() async {
    if (photo != null) {
      final directory = await getTemporaryDirectory();
      DateTime now = DateTime.now();
      String currentTime = '${now.second}${now.minute}${now.microsecond}';
      String finalNombreImagen = "${currentTime}tomada.png";

      String newPath = '${directory.path}/$finalNombreImagen';

      // Renombrar la imagen
      File originalFile = File(photo!.path);
      await originalFile.copy(newPath);

      setState(() {
        _imageFile = File(newPath); // Actualiza la imagen
        _imageName = finalNombreImagen;
      });
      return 1;
    } else {
      return 0;
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
  void initState() {
    // TODO: implement initState
    _checkSession();
    traerIdiomas();
    super.initState();
  }

  Future<void> traerIdiomas() async {
    imagen = Imagen();
    List<dynamic> items = [];
    items = await imagen.mostrarIdiomas();

    for (var t in items) {
      itemsFinal.add(
        DropdownMenuItem<String>(
          value: "${t['prefijo']}",
          child: Text('Opción : ${t["idioma"]}'),
        ),
      );
    }
  }

  String? selectedOption;
  String textocapturado =
      "Son los que tienen como característica que nacen con la forma típica de un pez, y van variando durante su crecimiento hasta hacerse planos, para poder vivir pegados al fondo marino. De aquí que tengan los dos ojos en el mismo lado de la cara, la boca torcida y las aletas pectorales una encima de otra.";

  String textotraducido =
      "Son los que tienen como característica que nacen con la forma típica de un pez, y van variando durante su crecimiento hasta hacerse planos, para poder vivir pegados al fondo marino. De aquí que tengan los dos ojos en el mismo lado de la cara, la boca torcida y las aletas pectorales una encima de otra.";

  String imageUrl =
      'https://cdn.pixabay.com/photo/2023/02/07/14/45/translation-7774314_1280.jpg';
  String imageUrl2 =
      'https://cdn.pixabay.com/photo/2023/02/07/14/45/translation-7774314_1280.jpg';

  void _createImageInstance() async {
    if (_imageFile != null && _imageName != null) {
      imagen = Imagen.constructorImagen(
        archivo: _imageFile!,
        nombre: _imageName!,
      );
      imagen.opcionSeleccionada = selectedOption;

      int retorno = await imagen.uploadImage(_imageFile!, _imageName!);

      if (retorno == 1) {
        AlertaMensaje.showSnackBar(
            // ignore: use_build_context_synchronously
            context,
            "Subiendo Imagen Al Servidor...",
            Colors.orange);
        int retorno1 = await imagen.iniciarTodo();

        String fileEscaneado = imagen.fileEscaneado(_imageName!);
        String fileTraducido = imagen.fileTraducido(_imageName!);

        if (retorno1 == 1) {
          AlertaMensaje.showSnackBar(
              // ignore: use_build_context_synchronously
              context,
              "Traduciendo texto...",
              Colors.orange);
          setState(() {
            if (fileEscaneado != "") {
              items2.clear();
              imageUrl = fileEscaneado;
              imageUrl2 = fileTraducido;
              textocapturado = imagen.textoescaneado!;
              textotraducido = imagen.textotraducido!;
              List<dynamic> items = [];

              items = imagen.separarCadena(textocapturado, textotraducido);

              for (var t in items) {
                String cuenta = t["contador"];
                String titulo = t["titulo"];
                String tra = t["descripcion"];
                var adde = {
                  'contador': cuenta,
                  'titulo': "${"'$titulo"}'",
                  'descripcion': "${"'$tra"}'"
                };
                items2.add(adde);
              }
            }
          });
        }
      } else {
        AlertaMensaje.showSnackBar(
            // ignore: use_build_context_synchronously
            context,
            "Texto no encontrado en la imagen",
            errorColor);
      }
    } else {
      AlertaMensaje.showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          "Error al escanear la imagen.",
          errorColor);
    }
  }

  List<Map<String, String>> items2 = List.generate(
    1,
    (index) => {
      'contador': 'Hola',
      'titulo': 'Bienvenido A',
      'descripcion': 'Genesis',
    },
  );

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => TomarfotoProvider(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                    text: "Archivos",
                    icon: Icons.file_present_sharp,
                    onClicked: () {
                      getImageFromGallery();
                    },
                    color1: ccolor2,
                    color2: ccolor1,
                    isborder: false,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  photo == null
                      ? const Icon(
                          Icons.photo,
                          color: ccolor1,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
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
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 4.0,
                                child: Image.file(
                                  File(
                                    photo!.path,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 6,
                  ),
                  photo != null
                      ? ButtonWidget(
                          text: "Iniciar Scan",
                          icon: Icons.file_present,
                          onClicked: () async {
                            int retorno = await cambiarNombreImagen();
                            if (retorno == 1) {
                              _createImageInstance();
                            }
                          },
                          color1: ccolor2,
                          color2: ccolor1,
                          isborder: false,
                        )
                      : const SizedBox(
                          height: 6,
                        ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const Text(
                    "Selecciona Idioma De La Traducción. 😃 ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: ccolor1),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  DropdownButton<String>(
                      hint: const Text('Elegir idioma'),
                      value: selectedOption,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18),
                      borderRadius: BorderRadius.circular(12),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue;
                        });
                      },
                      items: itemsFinal),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Theme.of(context).colorScheme.background,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                -2, 1), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            style: BorderStyle.solid,
                            width: 2)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: InteractiveViewer(
                              minScale: 0.5,
                              maxScale: 4.0,
                              child: Image.network(
                                imageUrl,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Imagen Escaneada",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonWidget(
                                  text: "Guardar",
                                  icon: Icons.save,
                                  onClicked: () async {
                                    if (imagen.estado == 1) {
                                      String url =
                                          "https://repositorioprivado.onrender.com/descargarImagenEscaneado/${_imageName!}";

                                      int retorno = await imagen
                                          .subirimagenServidorinicial(
                                              url, _imageName!);
                                      if (retorno == 1) {
                                        AlertaMensaje.showSnackBar(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            "Imagen Guardada correctamente!!",
                                            Colors.orange);
                                      } else {
                                        AlertaMensaje.showSnackBar(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            "Error al Guardar la imagen",
                                            errorColor);
                                      }
                                    } else {
                                      AlertaMensaje.showSnackBar(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          "Error al Guardar la imagen",
                                          errorColor);
                                    }
                                  },
                                  color1: ccolor2,
                                  color2: ccolor1,
                                  isborder: false,
                                ),
                                ButtonWidget(
                                    text: "Descargar",
                                    icon: Icons.download_for_offline_rounded,
                                    onClicked: () async {
                                      if (imagen.estado == 1) {
                                        String url =
                                            "https://repositorioprivado.onrender.com/descargarImagenEscaneado/${_imageName!}";

                                        int retorno =
                                            await imagen.downloadFile2(url);
                                        if (retorno == 1) {
                                          AlertaMensaje.showSnackBar(
                                              // ignore: use_build_context_synchronously
                                              context,
                                              "Imagen descargada correctamente!!",
                                              Colors.orange);
                                        } else {
                                          AlertaMensaje.showSnackBar(
                                              // ignore: use_build_context_synchronously
                                              context,
                                              "Error al descargar la imagen.",
                                              errorColor);
                                        }
                                      } else {
                                        AlertaMensaje.showSnackBar(context,
                                            "Imagen no cargada", errorColor);
                                      }
                                    },
                                    color1: ccolor2,
                                    color2: ccolor1,
                                    isborder: false)
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Theme.of(context).colorScheme.background,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                -2, 1), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            style: BorderStyle.solid,
                            width: 2)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: InteractiveViewer(
                              minScale: 0.5,
                              maxScale: 4.0,
                              child: Image.network(
                                imageUrl2,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Imagen Traducida",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ButtonWidget(
                                      text: "Guardar",
                                      icon: Icons.save,
                                      onClicked: () async {
                                        if (imagen.estado == 1) {
                                          String url =
                                              "https://repositorioprivado.onrender.com/descargarImagenTraducido/${_imageName!}";

                                          int retorno = await imagen
                                              .subirimagenServidorinicial(
                                                  url, _imageName!);
                                          if (retorno == 1) {
                                            AlertaMensaje.showSnackBar(
                                                // ignore: use_build_context_synchronously
                                                context,
                                                "Imagen Guardada correctamente!!",
                                                Colors.orange);
                                          } else {
                                            AlertaMensaje.showSnackBar(
                                                // ignore: use_build_context_synchronously
                                                context,
                                                "Error al Guardar la imagen",
                                                errorColor);
                                          }
                                        } else {
                                          AlertaMensaje.showSnackBar(
                                              // ignore: use_build_context_synchronously
                                              context,
                                              "Error al Guardar la imagen",
                                              errorColor);
                                        }
                                      },
                                      color1: ccolor2,
                                      color2: ccolor1,
                                      isborder: false),
                                  ButtonWidget(
                                      text: "Descargar",
                                      icon: Icons.download_for_offline_rounded,
                                      onClicked: () async {
                                        if (imagen.estado == 1) {
                                          String url =
                                              "https://repositorioprivado.onrender.com/descargarImagenTraducido/${_imageName!}";

                                          int retorno =
                                              await imagen.downloadFile2(url);
                                          if (retorno == 1) {
                                            AlertaMensaje.showSnackBar(
                                                // ignore: use_build_context_synchronously
                                                context,
                                                "Imagen descargada correctamente!!",
                                                Colors.orange);
                                          } else {
                                            AlertaMensaje.showSnackBar(
                                                // ignore: use_build_context_synchronously
                                                context,
                                                "Error al descargar la imagen.",
                                                errorColor);
                                          }
                                        } else {
                                          AlertaMensaje.showSnackBar(context,
                                              "Imagen no cargada", errorColor);
                                        }
                                      },
                                      color1: ccolor2,
                                      color2: ccolor1,
                                      isborder: false)
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Theme.of(context).colorScheme.background,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                -2, 1), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            style: BorderStyle.solid,
                            width: 2)),
                    child: Column(
                      children: [
                        const Text(
                          "Texto Capturado",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          textocapturado,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          "Texto Traducido",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          textotraducido,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ButtonWidget(
                              text: "",
                              icon: Icons.picture_as_pdf,
                              onClicked: () async {
                                if (imagen.estado == 1) {
                                  int retorno = await imagen.descargarpdf(
                                      "pdf", "resultadosTraduccion.pdf");
                                  if (retorno == 1) {
                                    AlertaMensaje.showSnackBar(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        "Archivo pdf descargado correctamente!!",
                                        Colors.orange);
                                  } else {
                                    AlertaMensaje.showSnackBar(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        "Error al descargar el archivo",
                                        errorColor);
                                  }
                                } else {
                                  AlertaMensaje.showSnackBar(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      "Error al descargar el archivo",
                                      errorColor);
                                }
                              },
                              color1: ccolor2,
                              color2: ccolor1,
                              isborder: false,
                            ),
                            ButtonWidget(
                              text: "",
                              icon: Icons.document_scanner_outlined,
                              onClicked: () async {
                                if (imagen.estado == 1) {
                                  int retorno = await imagen.descargarpdf(
                                      "pdf", "resultadosTraduccion.pdf");
                                  if (retorno == 1) {
                                    AlertaMensaje.showSnackBar(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        "Archivo txt descargado correctamente!!",
                                        Colors.orange);
                                  } else {
                                    AlertaMensaje.showSnackBar(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        "Error al descargar el archivo",
                                        errorColor);
                                  }
                                } else {
                                  AlertaMensaje.showSnackBar(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      "Error al descargar el archivo",
                                      errorColor);
                                }
                              },
                              color1: ccolor2,
                              color2: ccolor1,
                              isborder: false,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 324,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Theme.of(context).colorScheme.background,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                -2, 1), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            style: BorderStyle.solid,
                            width: 2)),
                    child: ListView.builder(
                      itemCount: items2.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 0),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ccolor2, // Customize border color
                              width: 1.0, // Customize border width
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: ListTile(
                            title: Text(
                              "${items2[index]["contador"]!} ${items2[index]["titulo"]!}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              items2[index]["descripcion"]!,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                color: ccolor2),
                            titleAlignment: ListTileTitleAlignment.center,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
}

class TomarfotoProvider extends ChangeNotifier {
  String _nombreFoto = '';
  String get nombreUsuario => _nombreFoto;

  set nombreFototomada(String nuevoNombre) {
    _nombreFoto = nuevoNombre;
    notifyListeners();
  }
}
