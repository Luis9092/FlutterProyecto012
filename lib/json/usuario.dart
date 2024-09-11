import 'dart:convert';

Usuario usersFromMap(String str) => Usuario.fromMap(json.decode(str));
String usersToMap(Usuario data) => json.encode(data.toMap());

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

  Usuario.view(
      {this.idUsuario,
      this.nombres,
      this.apellidos,
      this.correo,
      this.imagen,
      this.theme,
      this.estado});

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario.view(
      idUsuario: json["idUsuario"],
      nombres: json["nombres"],
      apellidos: json["apellidos"],
      correo: json["correo"],
      imagen: json["imagen"],
      theme: json["theme"],
      estado: json["estado"]);

  Map<String, dynamic> toMap() => {
        "idUsuario": idUsuario,
        "nombres": nombres,
        "apellidos": apellidos,
        "correo": correo,
        "contrasenia": contrasenia,
        "imagen": imagen,
        "estado": estado,
        "theme": theme,
        "fechaNacimiento": fechaNaciminiento,
        "fechaCreacion": fechaCreacion,
        "fechaActualizacion": fechaActualizacion,
      };
}
