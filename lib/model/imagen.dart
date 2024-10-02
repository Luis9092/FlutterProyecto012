import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

class Imagen {
  File? archivo;
  String? nombre;
  String? opcionSeleccionada;
  String? textoescaneado;
  String? textotraducido;

  Imagen();

  Imagen.constructorImagen({required this.archivo, required this.nombre});

  Future<int> iniciarTodo() async {
    // todoexito
    int retorno = await _uploadImage(archivo!, nombre!);
    String tamanio = await dimensiones();
    String formato = archivo!.path.split('.').last;
    String? idUsuario = await getidUser();

    if (retorno == 1) {
      print("Imagen Subida correctamente al servidor");
      int retorno2 = await iniciarScan(idUsuario!, nombre!, tamanio, formato);
      if (retorno2 == 1) {
        await iniciarTraduccion(nombre!, opcionSeleccionada);
        await traerData();
        return 1;
      } else {
        return 0;
      }
    } else {
      print("Error al subir la imagen");
      return 0;
    }
  }

  Future<int> _uploadImage(File imageFile, String nombre) async {
    final uri = Uri.parse(
        'https://repositorioprivado.onrender.com/subirImagenServer'); // Cambia esto por tu URL de la API
    var request = http.MultipartRequest('POST', uri);

    // Agregar el archivo a la solicitud
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    // Enviar la solicitud
    var response = await request.send();

    if (response.statusCode == 200) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<http.Response> enviarDatosAPIScan(
      String url, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return response;
  }

  Future<http.Response> enviarDatosAPISTraducir1(
      String url, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return response;
  }

  Future<int> iniciarScan(
      String idUser, String nombre, String tamanio, String formato) async {
    const url = 'https://repositorioprivado.onrender.com/IniciarScanImage';
    final data = {
      'id': "",
      'idUser': idUser,
      'nombre': nombre,
      'tamanio': tamanio,
      'formato': formato,
      'fechaCreacion': "",
    };

    try {
      final response = await enviarDatosAPIScan(url, data);
      if (response.statusCode == 200) {
        print("Scan iniciado correctamente!");
        return 1;
      } else {
        print("Error al iniciar el scan");
        return 0;
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<String?> getidUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("idbvar");
  }

  Future<String> dimensiones() async {
    if (await archivo!.exists()) {
      // Leer la imagen
      final imageBytes = await archivo!.readAsBytes();
      // Decodificar la imagen
      final image = img.decodeImage(imageBytes);
      int? width = image?.width;
      int? height = image?.height;
      String dimensiones = (width != null && height != null)
          ? '$width x $height píxeles'
          : 'Dimensiones no disponibles';
      return dimensiones;
    } else {
      print('El archivo no existe.');
      return "";
    }
  }

  Future<List> mostrarIdiomas() async {
    final url = Uri.parse('https://repositorioprivado.onrender.com/verIdiomas');

    try {
      // Enviar la solicitud GET
      final response = await http.get((url));

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        // print('Usuario autenticado correctamente: ${response.body}');
        // jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        List<dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> items = [];

        for (var item in jsonResponse) {
          final adde = {};
          adde["idioma"] = item['nombreIdioma'];
          adde["prefijo"] = item['abreviacion'];
          items.add(adde);
        }

        // print(data);
        return items;
      } else {
        // print('Error al ver Idiomas: ${response.statusCode}');
        // print('Respuesta del servidor: ${response.body}');
        return [];
      }
    } catch (e) {
      // print('Excepción al ver Idiomas usuario: $e');
      return [];
    }
  }

  Future<int> iniciarTraduccion(
      String nombreImagen, String? opcionSeleccionada) async {
    print(opcionSeleccionada);

    if (opcionSeleccionada != null) {
      const url = 'https://repositorioprivado.onrender.com/traducirTextoImage';
      final data = {
        'id': 0,
        'name_file': nombreImagen,
        'idiomaTraducir': opcionSeleccionada,
      };

      try {
        final response = await enviarDatosAPISTraducir1(url, data);
        if (response.statusCode == 200) {
          print("Texto traducido correctamente correctamente!");
          return 1;
        } else {
          print("Error al iniciar la traduccion");
          return 0;
        }
      } catch (e) {
        print('Error: $e');
        return 0;
      }
    } else {
      print("Ningun idioma seleccionado");
      return 0;
    }
  }

  Future<void> traerData() async {
    final url =
        Uri.parse('https://repositorioprivado.onrender.com/ObtenerDataImagen');

    try {
      // Enviar la solicitud GET
      final response = await http.get((url));

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        // print('Usuario autenticado correctamente: ${response.body}');
        final Map<String, dynamic> data =
            json.decode(utf8.decode(response.bodyBytes));
        print(data);
        textoescaneado = data["textoextraido"];
        textotraducido = data["textotraducido"];
        // separarCadena(data["palabras"], data["traduccionpalabras"]);
      } else {
        print('Error al traeer data : ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      print('Excepción al traer data usuario: $e');
    }
  }

  String fileEscaneado(String name) {
    try {
      String direccion =
          "https://repositorioprivado.onrender.com/fileEscaneado/$name";
      return direccion;
    } catch (e) {
      // Manejo de errores
      print("Ocurrió un error: $e");
      return "";
    }
  }

  String fileTraducido(String name) {
    try {
      String direccion =
          "https://repositorioprivado.onrender.com/fileTraducido/$name";
      return direccion;
    } catch (e) {
      // Manejo de errores
      print("Ocurrió un error: $e");
      return "";
    }
  }

  List separarCadena(String texto, String traducir) {
    String textoLimpio = texto.replaceAll(RegExp(r'[",.]'), '');
    String textoLimpio2 = traducir.replaceAll(RegExp(r'[",.]'), '');
   
    List<String> palabras = textoLimpio.split(' ');
    List<String> traduccion = textoLimpio2.split(' ');
    // Imprimir la lista de palabras
    int minLength = palabras.length < traduccion.length
        ? palabras.length
        : traduccion.length;
    final List<dynamic> items = [];

    for (int i = 0; i < minLength; i++) {
      var adde = {};
      String numeroComoString = i.toString();
      String palabras2 = palabras[i];
      String traduccion2 = traduccion[i];
      adde = {
        'contador': "${"'$numeroComoString"}'",
        'titulo': "${"'$palabras2"}'",
        'descripcion': "${"'$traduccion2"}'"
      };

      items.add(adde);
    }
    return items;
  }
}
