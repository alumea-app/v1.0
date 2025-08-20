import 'package:alumea/features/journey/domain/journey_entry.dart';
import 'package:alumea/features/journey/presentation/widgets/timeline_painter.dart';
import 'package:flutter/material.dart';

class TimeLineNode extends StatelessWidget {
  final JourneyEntry entry;
  final bool isFirst;
  final bool isLast;
  const TimeLineNode({
    super.key,
    required this.entry,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final IconData iconData;
    final Color iconColor;

    switch (entry) {
      case CheckInJourneyEntry():
        iconData = Icons.sentiment_satisfied; // Placeholder
        iconColor = Theme.of(context).primaryColor;
        break;
      case ConversationJourneyEntry():
        iconData = Icons.chat_bubble_outline_outlined; // Placeholder
        iconColor = Theme.of(context).primaryColor;
        break;

      default:
        iconData = Icons.circle;
        iconColor = Theme.of(context).primaryColor;
    }

    return SizedBox(
      width: 40, // Width for the timeline painter
      child: CustomPaint(
        painter: TimelinePainter(
          isFirst: isFirst,
          isLast: isLast,
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                iconData,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
