import 'package:flutter/material.dart';

class AlertaMensaje {
  static void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.background,
            fontWeight: FontWeight.bold,
            
          ),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Cerrar',
          textColor: Theme.of(context).colorScheme.background,
          onPressed: () {
            
          },
        ),
      ),
    );
  }
}
