import 'dart:convert';
import 'dart:io';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

class Imagen {
  File? archivo;
  String? nombre;
  String? opcionSeleccionada;
  String? textoescaneado;
  String? textotraducido;
  String? idiomaOrigen;
  String? idiomafinal;
  int estado = 0;
  String? idimagen;
  String? cadenaPalabras;
  String? cadenaTraduccion;

  Imagen();

  Imagen.constructorImagen({required this.archivo, required this.nombre});

  Future<int> iniciarTodo() async {
    estado = 0;

    try {
      String tamanio = await dimensiones();
      String formato = archivo!.path.split('.').last;
      String? idUsuario = await getidUser();

      int retorno2 = await iniciarScan(
          idUsuario!, nombre!, tamanio, formato, opcionSeleccionada!);

      if (retorno2 == 1) {
        estado = 1;
        return 1;
      } else {
        estado = 0;
        return 0;
      }
    } catch (e) {
      // Manejo de errores
      estado = 0;
      print('Error: $e');
      return 0; // O el valor que consideres para indicar un error
    }
  }

  Future<int> uploadImage(File imageFile, String nombre) async {
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

  Future<int> iniciarScan(String idUser, String nombre, String tamanio,
      String formato, String opcion) async {
    const url = 'https://repositorioprivado.onrender.com/IniciarScanImage';
    final data = {
      'id': "",
      'idUser': idUser,
      'nombre': nombre,
      'tamanio': tamanio,
      'formato': formato,
      'fechaCreacion': "",
      'idiomatraducir': opcion
    };

    try {
      final response = await enviarDatosAPIScan(url, data);
      if (response.statusCode == 200) {
        // print("Scan iniciado correctamente!");
        final Map<String, dynamic> data =
            json.decode(utf8.decode(response.bodyBytes));
        print(data);

        textoescaneado = data["textoextraido"];
        textotraducido = data["textotraducido"];
        idimagen = data["idimagen"];
        idiomaOrigen = data["idiomaorigen"];
        idiomafinal = data["idiomatraduccion"];
        cadenaPalabras = data["palabras"];
        cadenaTraduccion = data["traduccionpalabras"];

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

  Future<String?> getCorreo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("correovar");
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
      // print('El archivo no existe.');
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

 

  String fileEscaneado(String name) {
    try {
      String direccion =
          "https://repositorioprivado.onrender.com/fileEscaneado/$name";
      return direccion;
    } catch (e) {
      // Manejo de errores
      // print("Ocurrió un error: $e");
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
      // print("Ocurrió un error: $e");
      return "";
    }
  }

  List separarCadena(String texto, String traducir) {
    // String textoLimpio = texto.replaceAll(RegExp(r'[",.]'), '');
    // String textoLimpio2 = traducir.replaceAll(RegExp(r'[",.]'), '');

    List<String> palabras = cadenaPalabras!.split(',');
    List<String> traduccion = cadenaTraduccion!.split(',');

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

  Future<int> downloadFile2(String file) async {
    int retorno = 0;

    await FileDownloader.downloadFile(
      url: file,
      onProgress: (name, progress) {
        // print('FILE fileName $name HAS PROGRESS $progress');
      },
      onDownloadCompleted: (String path) {
        // print('FILE DOWNLOADED TO PATH: $path');
        retorno = 1;
      },
      onDownloadError: (String error) {
        // print('DOWNLOAD ERROR: $error');
        retorno = 0;
      },
    );

    return retorno;
  }

  Future<void> subirImagenAlServidor1(
      String filePath, String idUsuario, String idimagen, String apiUrl) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Agregar el archivo al request
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    // Agregar el string al request
    request.fields['param1'] = idUsuario;
    request.fields['param2'] = idimagen;

    // Enviar la solicitud
    var response = await request.send();

    // Comprobar la respuesta
    if (response.statusCode == 200) {
      print('Archivo y texto enviados correctamente.');
    } else {
      print('Error al enviar: ${response.statusCode}');
    }
  }

  Future<int> subirimagenServidorinicial(String url, String name) async {
    try {
      String urlEnviar =
          "https://repositorioprivado.onrender.com/guardarImagenResultado";

      // Get user ID
      String? idUsuario = await getidUser();
      String fileimagen = await convertUrlToFile(url, name);
      if (fileimagen != "") {
        await subirImagenAlServidor1(
            fileimagen, idUsuario!, idimagen!, urlEnviar);

        return 1;
      } else {
        return 0;
      }
    } catch (error) {
      print("Error: $error");
      return 0;
    }
  }

  Future<String> convertUrlToFile(String url, String name) async {
    // Descargar el contenido de la URL
    try {
      // Realizar la solicitud GET
      final response = await http.get(Uri.parse(url));

      // Comprobar si la respuesta fue exitosa
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Crear un directorio temporal
        final tempDir = await getTemporaryDirectory();

        // Crear un nuevo archivo en el directorio temporal
        final file = File(
            '${tempDir.path}/$name'); // Ajusta la extensión según el tipo de archivo
        await file.writeAsBytes(bytes);

        return file.path;
      } else {
        print('Error al descargar el archivo: ${response.statusCode}');
        return "";
      }
    } catch (e) {
      print('Ocurrió un error: $e');
      return "";
    }
  }

  Future<int> descargarpdf(String tipoarchivo, String nombrefile) async {
    String? idUsuario = await getidUser();
    String? correo = await getCorreo();
    String? texto = textoescaneado;
    String? traduccion = textotraducido;
    String? idImagen = idimagen;

    String? origenIdioma = idiomaOrigen;
    String? finalidioma = idiomafinal;
    String tipoArchivo = tipoarchivo;
    DateTime now = DateTime.now();

    String currentTime = '${now.second}${now.minute}${now.microsecond}';
    
    String nombreImagen = "$currentTime$nombrefile";

    const url = 'https://repositorioprivado.onrender.com/creararchivo';
    final data = {
      'idresultado': idUsuario,
      'idImagenResultado': idImagen,
      'texto': texto,
      'traduccion': traduccion,
      'correo': correo,
      'nombre': nombreImagen,
      'idiomaOrigen': origenIdioma,
      'idiomaTraduccion': finalidioma,
      'tipoArchivo': tipoArchivo
    };

    try {
      final response = await enviarDatosAPISpdf(url, data);
      if (response.statusCode == 200) {
        String url =
            "https://repositorioprivado.onrender.com/descargararchivo/${nombreImagen}";

        await downloadFile2(url);

        print("finalArchivo iniciado correctamente!");

        return 1;
      } else {
        print("FinalArchivoError al iniciar el scan");
        return 0;
      }
    } catch (e) {
      print('FinalError: $e');
      return 0;
    }
  }

  Future<http.Response> enviarDatosAPISpdf(
      String url, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return response;
  }
}
