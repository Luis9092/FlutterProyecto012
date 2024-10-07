import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ResultadosImagen {
  String? id;
  String? idImagen;
  String? nombreImagen;
  String? fecha;
  String? estado;
  List? lista;
  ResultadosImagen();

  Future<int> verResultados() async {
    String? id = await getidUser();

    final url = Uri.parse(
        'https://repositorioprivado.onrender.com/verResultadosGuardados/<id>?id=$id');

    try {
      // Enviar la solicitud GET
      final response = await http.get((url));

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        // print('Usuario autenticado correctamente: ${response.body}');
        List jsonResponse = json.decode(response.body);
        lista = jsonResponse;

        return 1;
      } else {
        print('Error al traeer data : ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        return 0;
      }
    } catch (e) {
      print('Excepción al traer data usuario: $e');
      return 1;
    }
  }

  Future<String?> getidUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("idbvar");
  }

  Future<List> enviarDatosre() async {
    final List<dynamic> items = [];

    for (var item in lista!) {
      var adde = {};
      adde = {
        'imagen': item['pathArchivo'],
        'idresultado': item['idresultado'],
        'nombreArchivo': item['nombreArchivo'],
        'fechacreacion': item['fechacreacion']
      };
      items.add(adde);
    }
    print(items);
    return items;
  }

  // Future<void> traerData() async {
  //   final url =
  //       Uri.parse('https://repositorioprivado.onrender.com/ObtenerDataImagen');

  //   try {
  //     // Enviar la solicitud GET
  //     final response = await http.get((url));

  //     // Verificar el estado de la respuesta
  //     if (response.statusCode == 200) {
  //       // print('Usuario autenticado correctamente: ${response.body}');
  //       final Map<String, dynamic> data =
  //           json.decode(utf8.decode(response.bodyBytes));
  //       print(data);
  //       textoescaneado = data["textoextraido"];
  //       textotraducido = data["textotraducido"];
  //       // separarCadena(data["palabras"], data["traduccionpalabras"]);
  //     } else {
  //       print('Error al traeer data : ${response.statusCode}');
  //       print('Respuesta del servidor: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Excepción al traer data usuario: $e');
  //   }
  // }

  Future<int> eliminarResultadoUser(String itemId, String nameImagen) async {
    final response = await http.delete(
      Uri.parse(
          'https://repositorioprivado.onrender.com/eliminarArchivoUser/$itemId/$nameImagen'), // Cambia esto a tu URL de la API
    );

    if (response.statusCode == 200) {
      // Si el servidor devuelve un OK, entonces el item fue eliminado

      return 1;
    } else {
      return 0;
    }
  }
}
