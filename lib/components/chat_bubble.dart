import "package:flutter/material.dart";

class ChatBubble extends StatelessWidget {
  final bool isCurrentUser;
  final String message;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      decoration: BoxDecoration(
          color: isCurrentUser
              ? Theme.of(context).highlightColor
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16)),
      child: Text(
        message,
        style: TextStyle(color: isCurrentUser ? Colors.white : Theme.of(context).colorScheme.inversePrimary, fontSize: 15),
      ),
    );
  }
}
