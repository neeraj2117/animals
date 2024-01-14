import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Colors.black), // Change hint text color to black
        filled: true,
        fillColor: Colors.black.withOpacity(
            0.1), // Change text field background color to black with opacity
        contentPadding: const EdgeInsets.all(8),
        border: const OutlineInputBorder(
          // Customize border color
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          // Customize focused border color
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: const OutlineInputBorder(
          // Customize enabled border color
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      style: const TextStyle(
          color: Colors.black), // Change the text color to black
    );
  }
}
