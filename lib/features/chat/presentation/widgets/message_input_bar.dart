import 'package:alumea/core/app_theme.dart'; // Make sure you have your theme file
import 'package:flutter/material.dart';

class MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending; // <-- 1. ADD THE NEW PROPERTY
  final VoidCallback onSend;
  final FocusNode? focusNode;

  const MessageInputBar({
    super.key, 
    required this.controller, 
    this.isSending = false, // <-- 2. SET A DEFAULT VALUE
    this.focusNode,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.lightGrayBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.darkerGraySurface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 5,
                  minLines: 1,
                  controller: controller,
                   focusNode: focusNode,
                  // 3. DISABLE THE TEXT FIELD WHILE SENDING
                  enabled: !isSending, 
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            
            // --- Custom Send Button ---
            InkWell(
              // 4. If sending, the onTap is null (disabled). Otherwise, it's onSend.
              onTap: isSending ? null : onSend, 
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // 5. Visually show that the button is disabled.
                  color: isSending ? Colors.grey.shade300 : AppTheme.darkerGraySurface,
                  shape: BoxShape.circle,
                ),
                child: isSending
                  // 6. Show a progress indicator while sending.
                  ? const SizedBox(
                      width: 20, 
                      height: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  // Show the regular icon when not sending.
                  : const Icon(
                      Icons.arrow_forward_ios_rounded, 
                      color: AppTheme.textPrimary,
                      size: 20,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}