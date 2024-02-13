import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final Widget? icon;
  final String hintText;
  final bool obscure;
  final TextEditingController controller;
  final TextInputType? type;
  final Icon? prefixIcon;
  final int? maxLines;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  const MyTextField(
      {super.key,
      this.icon,
      required this.obscure,
      required this.hintText,
      required this.controller,
      this.type,
      this.prefixIcon,
      this.focusNode,
      this.onChanged,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.2, minHeight: screenHeight * 0.07),
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          keyboardType: type,
          maxLines: maxLines,
          minLines: 1,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            // isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary),
            ),
            icon: icon,
            hintText: hintText,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: screenHeight * 0.02),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true
          ),
          obscureText: obscure,
          // textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
