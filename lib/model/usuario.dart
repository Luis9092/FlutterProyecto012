import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Usuario {
  int? idUsuario;
  String? nombres;
  String? apellidos;
  String? correo;
  String? contrasenia;
  String? imagen;
  int? estado;
  int? theme;
  String? fechaNaciminiento;
  String? fechaCreacion;
  String? fechaActualizacion;

  Usuario();

  Usuario.construye(
      {this.idUsuario,
      this.nombres,
      this.apellidos,
      required this.correo,
      required this.contrasenia,
      this.imagen,
      required this.estado,
      required this.theme,
      required this.fechaNaciminiento,
      required this.fechaCreacion,
      this.fechaActualizacion});

  Future<http.Response> enviarDatosAPIA(
      String url, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    return response;
  }

  Future<int> enviarUsuario(Usuario usuario) async {
    const url = 'https://repositorioprivado.onrender.com/crearUsuario';
    final data = {
      'id': "",
      'nombres': usuario.nombres,
      'apellidos': usuario.apellidos,
      'correo': usuario.correo,
      'contrasenia': usuario.contrasenia,
      'imagen': "",
      'estado': 1,
      'theme': 1,
      'fechaCreacion': "",
      'fechaActualizacion': "",
      'idRole': 0,
      'fechaNacimiento': usuario.fechaNaciminiento,
    };

    try {
      final response = await enviarDatosAPIA(url, data);
      if (response.statusCode == 201) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      // print('Error: $e');
      return 0;
    }
  }

  Future<int> autenticarUsuario(String correo, String pas) async {
    // URL de la API de FastAPI con parámetros
    print(correo);
    print(pas);

    // var queryparams = {
    //   'correo': correo, // Here we pass the parameters.
    //   'pas': pas,
    // };

    final url = Uri.parse(
        'https://repositorioprivado.onrender.com/autenticarUsuario/<correo><pas>?correo=$correo&pas=$pas');

    try {
      // Enviar la solicitud GET
      final response = await http.get((url));

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        // print('Usuario autenticado correctamente: ${response.body}');
        final Map<String, dynamic> data = json.decode(response.body);
        // print(data);
        String nombres = data['nombres'];
        String correo = data['correo'];
        int theme = data['theme'];
        int estado = data['estado'];
        String id = data["id"];
        guardarUsuarioLogueado(id, correo, nombres, theme, estado);
        return 1;
      } else {
        // print('Error al autenticar usuario: ${response.statusCode}');
        // print('Respuesta del servidor: ${response.body}');
        return 0;
      }
    } catch (e) {
      // print('Excepción al autenticar usuario: $e');
      return 0;
    }
  }

  Future<void> guardarUsuarioLogueado(
      String id, String correo, String nombres, int thema, int estado) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('idbvar', id);
    prefs.setString('correovar', correo);
    prefs.setString('nombresvar', nombres);
    prefs.setString('imagenPath', "");
    prefs.setInt('themavar', thema);
    prefs.setInt('estadovar', estado);
  }

  Future<void> obtenerUsuarioLogueado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('estaLogueado') ?? "";
    prefs.getString('idbvar');
    prefs.getString('correovar');
    prefs.getString('nombresvar');
    prefs.getString('imagenPath');
    prefs.getInt('themavar');
    prefs.getInt('estadovar');
  }
}
