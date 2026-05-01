import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isUser = message.sender == 'user';
    
    return ListTile(
      title: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isUser ? Colors.deepPurple[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(message.content),
        ),
      ),
      subtitle: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(message.sender),
      ),
    );
  }
}
