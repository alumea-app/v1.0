import 'package:alumea/core/app_theme.dart';
import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({super.key, 
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isEmphasized = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    final color = isEmphasized ? AppTheme.accentCoral : AppTheme.primaryBlue;
    final bgColor = isEmphasized
        ? AppTheme.accentCoral.withValues(alpha: 0.1)
        : Colors.white;

    return Card(
      elevation: 0,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isEmphasized
            ? BorderSide.none
            : BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: color.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
