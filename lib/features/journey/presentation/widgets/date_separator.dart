import 'package:alumea/core/app_theme.dart';
import 'package:flutter/material.dart';

class DateSeparator extends StatelessWidget {
  final String date;
  const DateSeparator({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        date,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}
