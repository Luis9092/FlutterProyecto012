// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const Dropdown(
      {super.key,
      required this.hint,
      required this.icon,
      required this.controller,
      this.validator});

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
              prefixIconColor: Theme.of(context).colorScheme.secondary,
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                    width: 1,
                    style: BorderStyle.solid),
              )),
          validator: validator,
        ),
      ),
    );
  }
}
