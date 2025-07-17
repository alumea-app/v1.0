import 'package:alumea/core/app_theme.dart';
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUserMessage = message.sender == Sender.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isUserMessage
                  ? AppTheme.secondaryLavender
                  : AppTheme.darkerGraySurface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft:
                    isUserMessage ? const Radius.circular(20) : Radius.zero,
                bottomRight:
                    isUserMessage ? Radius.zero : const Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color:
                          isUserMessage ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                ),
                if (!isUserMessage) ...[
                  CircleAvatar(
                      child: SvgPicture.asset(
                    'assets/logo.svg',
                    height: 24,
                    color: Colors.white,
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
