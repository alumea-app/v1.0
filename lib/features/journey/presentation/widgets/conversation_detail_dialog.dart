import 'package:alumea/core/app_theme.dart';
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:alumea/features/chat/presentation/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ConversationDetailDialog extends StatelessWidget {
  final List<ChatMessage> messages;

  const ConversationDetailDialog({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      // Use the date of the first message as the title
      title: Text(DateFormat.yMMMMd().format(messages.first.timestamp!)),
      // Constrain the size of the dialog and make the content scrollable
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _ChatMessage(message: messages[index]);
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final ChatMessage message;
  const _ChatMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUserMessage = message.sender == Sender.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isUserMessage
                    ? AppTheme.secondaryLavender
                    : AppTheme.darkerGraySurface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isUserMessage
                      ? const Radius.circular(20)
                      : Radius.zero,
                  bottomRight: isUserMessage
                      ? Radius.zero
                      : const Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUserMessage) ...[
                    SvgPicture.asset(
                      'assets/logo.svg',
                      height: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isUserMessage
                            ? Colors.white
                            : AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
