
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => Container(
    
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 181, 160),
              Color.fromARGB(255, 0, 255, 225)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(66, 106, 106, 106), // Color de la sombra
              blurRadius: 4.0, // Desenfoque de la sombra
              spreadRadius: 1.0, // Expansión de la sombra
              offset: Offset(0, 2), // Desplazamiento de la sombra
            ),
          ],
          borderRadius: BorderRadius.circular(12),
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
                    fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ],
          ),
        ),
      );
}
