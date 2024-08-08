import 'package:flutter/material.dart';
import 'package:pro_graduacion/widget/button_widget.dart';
import 'package:pro_graduacion/widget/navigation_drawe.dart';

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

class CustomWidget extends StatelessWidget {
  final String message;
  final String name;
  // const CustomWidget({super.key}, name);
  const CustomWidget({super.key, required this.message, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
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
              "$name!!",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                    image: AssetImage(message),
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
                  onClicked: () {},
                )),
          ]),
        ),
      ),
    );
  }
}
