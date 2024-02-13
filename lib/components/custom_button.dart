import "package:flutter/material.dart";

class MyButton extends StatelessWidget {
  final Color color;
  final String text;
  final void Function()? onTap;
  const MyButton({super.key, required this.color, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: color,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: screenHeight * 0.025),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
