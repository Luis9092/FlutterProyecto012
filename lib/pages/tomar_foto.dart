import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/model/imagen.dart';
import 'package:pro_graduacion/pages/IniciarSesion.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:pro_graduacion/widget/navigation_drawe.dart';
import 'package:provider/provider.dart';
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
  File? _imageFile;
  String? _imageName;

  Imagen imagen = Imagen();
  List<DropdownMenuItem<String>> itemsFinal = [];

  Future getImageFromCamera() async {
    photo = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(photo!.path);
      _imageName = photo!.name;
    });
    _imageName = photo!.name;
  }

  // BuildContext? _dialogContext;

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
    _checkSession();
    super.initState();
    TraerIdiomas();
  }

  Future<void> TraerIdiomas() async {
    Imagen imagen = Imagen();
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
      Imagen imagen = Imagen.constructorImagen(
        archivo: _imageFile!,
        nombre: _imageName!,
      );
      imagen.opcionSeleccionada = selectedOption;

      int retorno = await imagen.iniciarTodo();
      print(selectedOption);

      if (retorno == 1) {
        String fileEscaneado = imagen.fileEscaneado(_imageName!);
        String fileTraducido = imagen.fileTraducido(_imageName!);

        setState(() {
          if (fileEscaneado != "") {
            imageUrl = fileEscaneado;
            imageUrl2 = fileTraducido;
            textocapturado = imagen.textoescaneado!;
            textotraducido = imagen.textotraducido!;
            List<dynamic> items = [];
            items = imagen.separarCadena(textocapturado, textotraducido);

            for (var t in items) {
              print(t);
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

      print('Imagen creada: ${imagen.nombre}');
    } else {
      print('No hay imagen para crear la instancia.');
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
                    height: 24,
                  ),
                  photo == null
                      ? const Icon(Icons.image)
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
                  Text(_imageName ?? ""),
                  const SizedBox(
                    height: 6,
                  ),
                  photo != null
                      ? ButtonWidget(
                          text: "Iniciar Scan",
                          icon: Icons.file_present,
                          onClicked: () {
                            _createImageInstance();
                          },
                          color1: ccolor1,
                          color2: ccolor2,
                          isborder: false,
                        )
                      : const SizedBox(
                          height: 6,
                        ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const Text(
                    "🤌 Elegir el idioma de la traducción ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ccolor2),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  DropdownButton<String>(
                      hint: const Text('Elegir idioma una opción'),
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
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset:
                              const Offset(-1, 2), // changes position of shadow
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
                          child: Image.network(
                            imageUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                    child: Text(
                      "Imagen Escaneada",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1),
                    ),
                  ),
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
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset:
                              const Offset(-1, 2), // changes position of shadow
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
                          child: Image.network(
                            imageUrl2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                    child: Text(
                      "Imagen Traducida",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        const Text(
                          "Texto Capturado",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          textocapturado,
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          "Texto Traducido",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          textotraducido,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                   
                      color: Theme.of(context).colorScheme.background,
                    ),
                    child: ListView.builder(
                      itemCount: items2.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        // return ListTile(
                        //   title: Text(
                        //       "${items2[index]["contador"]!}  ${items2[index]["titulo"]!}",
                        //       style: const TextStyle(
                        //           fontWeight: FontWeight.bold, fontSize: 18)),
                        //   subtitle: Text(items2[index]["descripcion"]!,
                        //       style: TextStyle(color: Colors.grey[600])),
                        //   trailing: const Icon(Icons.arrow_forward_ios,
                        //       color: Colors.grey),
                        //   titleAlignment: ListTileTitleAlignment.center,

                        // );
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

class Item {
  final String title;
  final String description;

  Item(this.title, this.description);
}
