import 'package:alumea/core/app_theme.dart';
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUserMessage = message.sender == Sender.user;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // This is the visible bubble container
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isUserMessage ? AppTheme.secondaryLavender : AppTheme.darkerGraySurface,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isUserMessage ? const Radius.circular(20) : Radius.zero,
                  bottomRight: isUserMessage ? Radius.zero : const Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lumi's avatar
                if (!isUserMessage) ...[
                  SvgPicture.asset('assets/logo.svg', height: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                ],
                
                Flexible(
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isUserMessage ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}