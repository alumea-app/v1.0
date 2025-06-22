import 'package:alumea/core/app_theme.dart';
import 'package:flutter/material.dart';

class MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInputBar(
      {super.key, required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SafeArea(
        // Ensures UI doesn't interfere with system areas like the home bar.
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
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "What's on your mind?",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: onSend,
              // By setting a customBorder, the ripple effect on tap will be a circle.
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(
                    12), // Adjust padding to get the desired size
                decoration: const BoxDecoration(
                  color:
                      AppTheme.darkerGraySurface, // The light gray background
                  shape: BoxShape.circle, // Makes the container circular
                ),
                child: const Icon(
                  // This icon is a very close match to your design.
                  Icons.arrow_forward_ios_rounded,
                  // Use our primary text color for the icon itself.
                  color: AppTheme.textPrimary,
                  size: 20, // Adjust size as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
