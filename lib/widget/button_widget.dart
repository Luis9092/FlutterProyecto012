import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;
  final Color color1;
  final Color color2;
  final bool isborder;

  const ButtonWidget(
      {super.key,
      required this.text,
      required this.icon,
      required this.onClicked,
      required this.color1,
      required this.color2,
      required this.isborder});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Color.fromARGB(255, 0, 181, 160),
              // Color.fromARGB(255, 0, 255, 225)
              color1, color2
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow, // Color de la sombra
              blurRadius: 1.0, // Desenfoque de la sombra
              spreadRadius: 1.0, // Expansión de la sombra
              offset: const Offset(0, 1), // Desplazamiento de la sombra
            ),
          ],
          border: isborder == false
              ? Border.all(color: Colors.transparent)
              : Border.all(color: Theme.of(context).colorScheme.background),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: onClicked,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              Icon(
                icon,
                size: 24,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
}
