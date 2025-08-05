// lib/features/journey/presentation/widgets/timeline_entry_card.dart
import 'package:alumea/features/journey/domain/journey_entry.dart';
import 'package:flutter/material.dart';
import 'achievement_banner.dart'; // We'll create this next

class TimelineEntry extends StatelessWidget {
  final JourneyEntry entry;
  final bool isFirst;
  final bool isLast;
  final bool isLeftAligned;

  const TimelineEntry({
    super.key,
    required this.entry,
    this.isFirst = false,
    this.isLast = false,
    this.isLeftAligned = true,
  });

  @override
  Widget build(BuildContext context) {
    if (entry.type == EntryType.dateSeparator) {
      return _DateSeparator(date: entry.title);
    }
    if (entry.type == EntryType.achievement) {
      return AchievementBanner(entry: entry);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // This creates the dual-axis layout
          if (!isLeftAligned) const Spacer(),
          Expanded(flex: 5, child: _ContentCard(entry: entry, isLeftAligned: isLeftAligned)),
          _TimelineNode(entry: entry, isFirst: isFirst, isLast: isLast),
          if (isLeftAligned) const Spacer(),
        ],
      ),
    );
  }
}

// -- PRIVATE HELPER WIDGETS --

class _ContentCard extends StatefulWidget {
  final JourneyEntry entry;
  final bool isLeftAligned;
  const _ContentCard({required this.entry, required this.isLeftAligned});

  @override
  __ContentCardState createState() => __ContentCardState();
}

class __ContentCardState extends State<_ContentCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: widget.isLeftAligned ? 0 : 20,
        right: widget.isLeftAligned ? 20 : 0,
        bottom: 24,
      ),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (widget.entry.subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.entry.subtitle!,
                    maxLines: _isExpanded ? null : 2, // Expansion logic
                    overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _TimelineNode extends StatelessWidget {
  final JourneyEntry entry;
  final bool isFirst;
  final bool isLast;
  const _TimelineNode({required this.entry, this.isFirst = false, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40, // Width for the timeline painter
      child: CustomPaint(
        painter: _TimelinePainter(
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
              child: Icon(entry.icon, size: 20, color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color color;

  _TimelinePainter({required this.isFirst, required this.isLast, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 2;

    final double centerX = size.width / 2;
    final double startY = isFirst ? size.height / 2 : 0;
    final double endY = isLast ? size.height / 2 : size.height;

    canvas.drawLine(Offset(centerX, startY), Offset(centerX, endY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DateSeparator extends StatelessWidget {
  final String date;
  const _DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        date,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }
}