import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_graduacion/pages/IniciarSesion.dart';
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
          backgroundColor: Theme.of(context).colorScheme.secondary,
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
  // const CustomWidget({super.key}, name);
  const CustomWidget({super.key, required this.message, required this.name});

  @override
  State<CustomWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String dos = "";
//TOMAR FOTO CAMARA <FUNCION>
  // XFile? photo;

  Future getImageFromCamera() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      dos = photo!.path;
    });
    print("Imagen Phat $dos");
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
                      vertical: 24.0, horizontal: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Image(
                      image: AssetImage(widget.message),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Expanded(
                flex: -1,
                child: ButtonWidget(
                  icon: Icons.image_sharp,
                  text: 'Actualizar Imagen',
                  onClicked: () {
                    _mostrarDialogo(context);
                  },
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
                  onClicked: () {}),
              const SizedBox(
                height: 12,
              ),
              ButtonWidget(
                  text: "Camara",
                  icon: Icons.camera_alt_outlined,
                  onClicked: () {
                    getImageFromCamera();
                    Provider.of<ImageNotifier>(context, listen: false)
                        .updateImagePath(dos);
                  }),
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