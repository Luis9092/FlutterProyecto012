import 'package:path/path.dart';
import 'package:pro_graduacion/json/users.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "auth.db";
  String user = '''
  CREATE TABLE users(
  usrId INTEGER PRIMARY KEY AUTOINCREMENT, 
  fullName TEXT, 
  email TEXT, 
  username TEXT UNIQUE, 
  usrPassword TEXT
  )
 ''';

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(user);
      
    });
  }

  Future<bool> autenticar(Users user) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "select * from users where username ='${user.username}' AND usrPassword ='${user.usrPassword}' ");

    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> createUser(Users user) async {
    final Database db = await initDB();
    return db.insert("users", user.toMap());
  }

  Future<Users?> getUser(String username) async {
    final Database db = await initDB();
    var result = await db.query(
      "users",
      where: "username = ?",
      whereArgs: [
        username,
      ],
    );
    return result.isNotEmpty? Users.fromMap(result.first) : null;
  }



}
