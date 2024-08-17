import 'package:flutter/material.dart';
import 'package:pro_graduacion/Components/InputFieldPassword.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/Components/inputField.dart';
import 'package:pro_graduacion/database/databasepro.dart';
import 'package:pro_graduacion/json/usuario.dart';
import 'package:pro_graduacion/pages/IniciarSesion.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:pro_graduacion/widget/alert_widget.dart';

class CrearCuenta extends StatefulWidget {
  const CrearCuenta({super.key});

  @override
  State<CrearCuenta> createState() => _CrearCuentaState();
}

class _CrearCuentaState extends State<CrearCuenta> {
  final nombres = TextEditingController();
  final apellidos = TextEditingController();
  final correo = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final imagen = "assets/images/userDefaul.jpg";
  final estado = 0;
  final theme = 0;
  final fechaNacimiento = TextEditingController();

  final fechaCreacion = DateTime.now().toString();
  final fechaActualizacion = "";

  // final db = DatabaseHelper();
  final db = Databasepro();

  crearUsuario() async {
    var retorno = await db.crearUsuario(
      Usuario.construye(
          nombres: nombres.text,
          apellidos: apellidos.text,
          correo: correo.text,
          contrasenia: password.text,
          imagen: imagen,
          estado: estado,
          theme: theme,
          fechaNaciminiento: fechaNacimiento.text,
          fechaCreacion: fechaCreacion,
          fechaActualizacion: ""),
    );
    if (retorno > 0) {
      if (!mounted) return;

      AlertaMensaje.showSnackBar(
        context,
        "Usuario Creado Correctamente",
        const Color.fromARGB(255, 85, 230, 217),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const IniciarSesion(),
        ),
      );
    }
  }

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 400, // Ajusta el ancho aquí
            height: 400, // Ajusta la altura aquí
            child: Theme(
              data: ThemeData.light().copyWith(
                buttonTheme:
                    const ButtonThemeData(textTheme: ButtonTextTheme.primary),

                colorScheme: ColorScheme.light(
                    primary: Theme.of(context)
                        .colorScheme
                        .secondary), // Color del esquema
              ),
              child: CalendarDatePicker(
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                onDateChanged: (DateTime date) {
                  Navigator.of(context).pop(date);
                },
              ),
            ),
          ),
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _validatePasswords() {
    if (password.text.isEmpty || confirmPassword.text.isEmpty) {
      AlertaMensaje.showSnackBar(
          context, 'Por favor, completa ambos campos', errorColor);
      return; // Salir del método si hay campos vacíos
    }

    if (password.text.length < 6) {
      AlertaMensaje.showSnackBar(context,
          'La contraseña debe tener al menos 6 caracteres', errorColor);
      return; // Salir del método si la contraseña es demasiado corta
    }

    if (password.text != confirmPassword.text) {
      AlertaMensaje.showSnackBar(
          context, 'Las contraseñas no coinciden', errorColor);
      return; // Salir del método si las contraseñas no coinciden
    }

    // Si todas las validaciones son exitosas
    AlertaMensaje.showSnackBar(context, 'Contraseñas válidas',
        const Color.fromARGB(255, 141, 185, 142));
    crearUsuario();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.primaryContainer
                ],
                begin: Alignment.bottomCenter,
                transform: const GradientRotation(12),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Registrarse",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 55,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  InputField(
                    hint: "Nombres",
                    icon: Icons.person,
                    controller: nombres,
                  ),
                  InputField(
                    hint: "Apellidos",
                    icon: Icons.person,
                    controller: apellidos,
                  ),
                  InputField(
                    hint: "Correo",
                    icon: Icons.email,
                    controller: correo,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        AlertaMensaje.showSnackBar(
                            context,
                            "El correo electrónico no puede estar vacío",
                            Colors.orange);
                        return '.';
                      }

                      final regex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!regex.hasMatch(value)) {
                        AlertaMensaje.showSnackBar(
                            context,
                            "Por favor, ingrese un correo electrónico válido.",
                            Colors.orange);
                        return ".";
                      }

                      return null;
                    },
                  ),
                  InputFieldPass(
                    hint: "Ingresar Password",
                    icon: Icons.password,
                    controller: password,
                    passwordInvisible: true,
                  ),
                  InputFieldPass(
                    hint: "Ingresar Confimar Password",
                    icon: Icons.password,
                    controller: confirmPassword,
                    passwordInvisible: false,
                  ),
                  Container(
                    width: size.width > 600 ? 400 : size.width * 0.9,
                    height: 60,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    child: Center(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        controller: TextEditingController(
                          text: (selectedDate == null
                              ? 'Fecha Nacimiento'
                              : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                        ),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "fecha Nacimiento",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 1,
                                style: BorderStyle.solid),
                          ),
                          prefix: Icon(
                            Icons.date_range_sharp,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          prefixIconColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        onTap: () => _selectDate(context),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  ButtonWidget(
                    text: "Registrarse",
                    onClicked: () {
                      if (_formKey.currentState?.validate() == true) {
                        // Procesar datos si son válidos

                        _validatePasswords();
                      } else {
                        AlertaMensaje.showSnackBar(context,
                            "Por favor verificar los datos", secondyColors);
                      }
                    },
                    icon: Icons.person_add_alt_1,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IniciarSesion(),
                            ),
                          );
                        },
                        child: Text(
                          "Ya tienes una cuenta?",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
