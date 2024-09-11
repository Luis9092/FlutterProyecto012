import 'package:flutter/material.dart';
import 'package:pro_graduacion/Components/colors.dart';
import 'package:pro_graduacion/widget/navigation_drawe.dart';

class AcercaDe extends StatelessWidget {
  const AcercaDe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acerca De"),
        centerTitle: true,
        backgroundColor: ccolor2,
      ),
      drawer: const NavigationDrawerWidget(),
      body: _cuerpo(context),
    );
  }

  Widget _cuerpo(context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: const Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Text("Version 1.1.0"),
          SizedBox(
            height: 12,
          ),
          Text("Luis Fernando Paxel"),
          Text("Con Fines De Aprendizaje, Derechos Reservados"),
        ],
      ),
    );
  }
}
