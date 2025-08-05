import 'package:alumea/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSeparator extends StatelessWidget {
  final DateTime date;

  const DateSeparator({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final isYesterday =
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1;

    String label;
    if (isToday) {
      label = "Today";
    } else if (isYesterday) {
      label = "Yesterday";
    } else {
      label = DateFormat('EEEE, d MMMM yyyy').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 0.5, color: AppTheme.primaryBlue)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(label),
          ),
          Expanded(child: Divider(thickness: 0.5, color: AppTheme.primaryBlue)),
        ],
      ),
    );
  }
}
