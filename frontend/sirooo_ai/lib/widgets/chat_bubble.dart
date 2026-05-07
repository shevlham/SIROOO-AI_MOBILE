import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_message.dart';
import '../utils/constants.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isUser = message.sender == 'user';
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) _buildAvatar(isUser),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isUser ? AppConstants.primaryGradient : null,
                    color: isUser ? null : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 0),
                      bottomRight: Radius.circular(isUser ? 0 : 20),
                    ),
                    boxShadow: isUser 
                      ? [BoxShadow(color: AppConstants.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]
                      : null,
                  ),
                  child: Text(
                    message.content,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isUser ? 'Sheva' : 'SIROOO AI',
                  style: GoogleFonts.outfit(
                    color: Colors.white54,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildAvatar(isUser),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isUser ? AppConstants.primaryGradient : AppConstants.accentGradient,
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Center(
        child: Icon(
          isUser ? Icons.person_rounded : Icons.auto_awesome_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
