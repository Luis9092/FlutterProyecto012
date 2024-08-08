// ignore_for_file: file_names

import 'package:flutter/material.dart';
// import 'package:pro_graduacion/Components/colors.dart';

class InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool? passwordInvisible;
  final TextEditingController controller;

  const InputField(
      {super.key,
      required this.hint,
      required this.icon,
      required this.controller,
      required this.passwordInvisible});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .9,
      margin: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.topCenter,
      child: Center(
        child: TextFormField(
          controller: controller,
          obscureText: passwordInvisible!,
          cursorColor: Theme.of(context).colorScheme.secondary,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                  style: BorderStyle.solid),
            ),
            prefixIcon: Icon(icon),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            labelText: hint,

            // suffixIcon: const Icon(Icons.no_encryption_gmailerrorred),
            prefixIconColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
