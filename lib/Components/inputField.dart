// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pro_graduacion/Components/colors.dart';

class InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const InputField(
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
          cursorColor: primaryColor,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                    style: BorderStyle.solid),
              ),
              prefixIcon: Icon(icon),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                ),
              ),
              labelText: hint,
              prefixIconColor: primaryColor,
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
