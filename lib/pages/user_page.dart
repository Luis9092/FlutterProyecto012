// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously, unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/pages/IniciarSesion.dart';
import 'package:pro_graduacion/pages/home.dart';
import 'package:pro_graduacion/widget/alert_widget.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:pro_graduacion/widget/navigation_drawe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatelessWidget {
  final String name;
  final String urlImage;

  const UserPage({
    super.key,
    required this.name,
    required this.urlImage,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: ccolor2,
          title: const Text("Foto De Perfil"),
          centerTitle: true,
        ),
        drawer: const NavigationDrawerWidget(),
        body: CustomWidget(message: urlImage, name: name),
      );
}

class CustomWidget extends StatefulWidget {
  final String message;
  final String name;
  const CustomWidget({super.key, required this.message, required this.name});

  @override
  State<CustomWidget> createState() => _CustomWidgetState();
}

//AQUI COMIENZA

class _CustomWidgetState extends State<CustomWidget> {
  Future<void> _checkSession() async {
    bool exists = await isSessionVariableExists('correovar');
    setState(() {
      exists;
      if (!exists) {
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

  String dos = "";
  BuildContext? _dialogContext;

  @override
  void initState() {
    super.initState();
    _checkSession();
    _loadSessionData();
  }

  //FUNCION PARA OBTENER EL ESTADO DEL USUARIO
  int? _estado;
  bool _isLoading = true;
  int? id;
  String? pathImageActual = "";

  Future<void> _loadSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('id') ?? 0;
    _estado = prefs.getInt("estado") ?? 0;
    dos = prefs.getString("ima") ?? "";
    pathImageActual = prefs.getString("ima") ?? "";

    setState(() {
      _isLoading = false; // Cambia el estado de carga
    });
  }

//TOMAR FOTO CAMARA <FUNCION>
  XFile? photo;

  Future getImageFromCamera() async {
    photo = await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo != null) {
      _cropImage(photo!.path);
      setState(() {
        dos = photo!.path;
        ImageNotifier().updateImagePath(photo!.path);
        Navigator.of(_dialogContext!).pop();
      });
    }
  }

  Future getImageFromGallery() async {
    photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (photo != null) {
      _cropImage(photo!.path);
      setState(() {
        dos = photo!.path;
        ImageNotifier().updateImagePath(photo!.path);

        Navigator.of(_dialogContext!).pop();
      });
    }
  }

  Future<void> _cropImage(String direccion) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: direccion,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedImage != null) {
      setState(() {
        dos = croppedImage.path;
        ImageNotifier().updateImagePath(croppedImage.path);
      });
      _saveImage(croppedImage.path);
    }
  }

  Future<void> _saveImage(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = DateTime.now().millisecondsSinceEpoch.toString();
    final File newImage = File('${directory.path}/$name.png');

    await File(imagePath).copy(newImage.path);
    setState(() {
      dos = newImage.path;
      ImageNotifier().updateImagePath(newImage.path);
    });
  }

  ///FUNCION PARA ACTUALIZAR IMAGEN
  // final db = Databasepro();
  // void actualizarImagenUser() async {
  //   try {
  //     // await Gal.putImage(dos, album: "Prueba1");
  //     var retorno = await db.actualizarImagenProfile(id!, dos, 1);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString("ima", dos);
  //     if (retorno == 1) {
  //       if (!mounted) return;

  //       AlertaMensaje.showSnackBar(
  //           context, "Imagen Actualizada Correctamente", ccolor2);
  //       _reloadPage(context);
  //     } else {
  //       AlertaMensaje.showSnackBar(
  //           context, "Error al actualizar la imagen", errorColor);
  //     }
  //   } catch (e) {
  //     // Manejo de excepciones
  //     AlertaMensaje.showSnackBar(context, "Ocurrió un error: $e", errorColor);
  //   }
  // }

  //RECARGAR PAGINA
  void _reloadPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageNotifier(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        width: double.maxFinite,
        height: double.infinity,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Flex(direction: Axis.vertical, children: [
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Hola Bienvenido(a), Que Tenga Buen Dia",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              Text(
                "${widget.name}!!",
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(-1, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 8.0),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: _estado == 0 && photo == null
                              ? InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 4.0,
                                child: Image(
                                    image: AssetImage(dos),
                                    fit: BoxFit.contain,
                                  ),
                              )
                              : InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 4.0,
                                child: Image.file(
                                    File(dos),
                                  ),
                              ),
                        ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Expanded(
                flex: -1,
                child: Column(
                  children: [
                    ButtonWidget(
                      icon: Icons.image_sharp,
                      text: 'Elegir Foto',
                      onClicked: () {
                        _mostrarDialogo(context);
                      },
                      color1: Colors.transparent,
                      color2: Theme.of(context).colorScheme.shadow,
                      isborder: true,
                      // color1: Color.fromARGB(255, 181, 0, 66),
                      // color2: Color.fromARGB(255, 255, 0, 93),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    photo == null
                        ? const SizedBox(
                            height: 1,
                          )
                        : ButtonWidget(
                            text: "Actualizar Imagen",
                            icon: Icons.update,
                            onClicked: () {
                              // actualizarImagenUser();
                            },
                            color1: ccolor1,
                            color2: ccolor2,
                            isborder: false),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        _dialogContext = context;
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          icon: const Icon(Icons.photo),
          alignment: Alignment.center,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 12,
              ),
              ButtonWidget(
                text: "Mis Archivos",
                icon: Icons.document_scanner,
                onClicked: () {
                  getImageFromGallery();
                },
                color1: ccolor1,
                color2: ccolor2,
                isborder: false,
              ),
              const SizedBox(
                height: 12,
              ),
              ButtonWidget(
                text: "Camara",
                icon: Icons.camera_alt_outlined,
                onClicked: () {
                  getImageFromCamera();
                },
                color1: ccolor1,
                color2: ccolor2,
                isborder: false,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ImageNotifier extends ChangeNotifier {
  String? _imagePath;

  String? get imagePath => _imagePath;

  void updateImagePath(String path) {
    _imagePath = path;
    notifyListeners(); // Notifica a los oyentes que el estado ha cambiado
  }
}

//COMPROBAR EL WIDGET PARA QUE SE ENLAZE CON EL NOTIFIER
//A LA HORA DE CREAR EL USUARIO, CREAR LA CARPETA Y LA IMAGEN, PARA QUE DESPUES AL ACTUALIZAR SOLO SE UTILICE UNA SOLA DIRECCION
// LA CARPETA SERA SOLO PARA UN USUARIO

//SOLO CON AGUARDAR LA DIRECCION DE LA IMAGEN, YA SE CREA AUTOMATICAMENTE

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
