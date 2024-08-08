import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/pages/IniciarSesion.dart';
import 'package:pro_graduacion/pages/crearCuenta.dart';
import 'package:pro_graduacion/theme/theme_provider.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  static const String title = 'Bienvenido';

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        home: const MainPage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
      );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        // drawer: const NavigationDrawerWidget(),
        // endDrawer: NavigationDrawerWidget(),
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text(
            MyApp.title,
          ),
          centerTitle: true,
        ),
        // body: const Index()
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "G",
                          style: TextStyle(
                              fontSize: 30,
                              color: primaryColor,
                              decoration: TextDecoration.overline,
                              decorationColor: primaryColor,
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          "enesis ",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "I",
                          style: TextStyle(
                              fontSize: 30,
                              color: primaryColor,
                              decoration: TextDecoration.overline,
                              decorationColor: primaryColor,
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          "mage",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "T",
                          style: TextStyle(
                              fontSize: 30,
                              color: primaryColor,
                              decoration: TextDecoration.overline,
                              decorationColor: primaryColor,
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          "ranslate",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Image.asset("assets/images/logo1.png",fit: BoxFit.contain, height: 100,),
                    const SizedBox(height: 20,),
                    SvgPicture.asset(
                      "assets/images/home.svg",
                      fit: BoxFit.contain,
                      height: 340,
                    ),
                   const SizedBox(height: 46,),
                    ButtonWidget(
                      text: "Iniciar Sesion",
                      icon: Icons.login,
                      onClicked: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IniciarSesion(),
                          ),
                        );
                      },
                    ),
                    ButtonWidget(
                      text: "Registrarse",
                      icon: Icons.login,
                      onClicked: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CrearCuenta(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 44,
                    ),
                    const Text("Version 1.0")
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.help,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}
