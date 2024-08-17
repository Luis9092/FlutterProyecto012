import 'package:pro_graduacion/json/usuario.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Databasepro {
  final namedatabase = "genesis.db";
  String usuario = '''
    CREATE TABLE usuarioGenesis(
    idUsuario INTEGER PRIMARY KEY AUTOINCREMENT,
    nombres TEXT,
    apellidos TEXT,
    correo TEXT UNIQUE,
    contrasenia TEXT,
    imagen TEXT, 
    estado INTEGER,
    theme INTEGER,
    fechaNacimiento TEXT,
    fechaCreacion TEXT,
    fechaActualizacion TEXT
    )
 ''';
  String galeriaResult = '''
  CREATE TABLE resultadoGaleria(
  idGaleriaResultado INTEGER PRIMARY KEY AUTOINCREMENT,
  idUser INTEGER,
  pathResultado TEXT,
  fechaHoraCreacion TEXT
  )
  ''';

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, namedatabase);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(usuario);
    });
  }

  Future<int> crearUsuario(Usuario user) async {
    final Database db = await initDB();
    return db.insert("usuarioGenesis", user.toMap());
  }

  Future<bool> autenticarUsuario(Usuario user) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "select * from usuarioGenesis where correo ='${user.correo}' AND contrasenia ='${user.contrasenia}' ");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<Usuario?> getUsers(String correo) async {
    final db = await initDB();
    var result = await db.query(
      'usuarioGenesis',
      columns: [
        'idUsuario',
        'nombres',
        'apellidos',
        'correo',
        'imagen',
        'theme'
      ],
      where: "correo = ?",
      whereArgs: [
        correo,
      ], // Selecciona solo los campos deseados
    );
    return result.isNotEmpty ? Usuario.fromMap(result.first) : null;
  }

  Future <void> actualizarTheme(int id, int theme) async {
    final db = await initDB();

    await db.update(
      'usuarioGenesis',
      {'theme': theme},
      where: 'idUsuario = ?',
      whereArgs: [
        id,
      ],
    );
  }

 

  Future<int?> getSwitchValue() async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps =
        await db.query('usuarioGenesis', where: 'idUsuario = ?', whereArgs: [1]);
    if (maps.isNotEmpty) {
      return maps.first['theme'] as int?;
    }
    return null;
  }
}
