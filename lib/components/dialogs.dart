import "package:flutter/material.dart";

class MyDialog extends StatelessWidget {
  final String text;
  final Widget icon;
  const MyDialog({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      icon: icon,
      title: Text(
        text,
        style: TextStyle(
            fontSize: screenHeight * 0.025,
            color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
