// ignore_for_file: file_names

import 'package:flutter/material.dart';
// import 'package:pro_graduacion/Components/colors.dart';

class InputFieldPass extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool passwordInvisible;
  final TextEditingController controller;

  const InputFieldPass(
      {super.key,
      required this.hint,
      required this.icon,
      required this.controller,
      required this.passwordInvisible});

  @override
  State<InputFieldPass> createState() => _InputFieldPassState();
}

class _InputFieldPassState extends State<InputFieldPass> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .9,
      margin: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.topCenter,
      child: Center(
        child: TextFormField(

          controller: widget.controller,
          obscureText: _obscureText,
          cursorColor: Theme.of(context).colorScheme.secondary,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                  style: BorderStyle.solid),
            ),
            prefixIcon: Icon(widget.icon),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            labelText: widget.hint,
            suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: _togglePasswordVisibility),
            prefixIconColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
