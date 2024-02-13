import "package:flutter/material.dart";

class CircleLoading extends StatelessWidget {
  const CircleLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.secondary),
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
