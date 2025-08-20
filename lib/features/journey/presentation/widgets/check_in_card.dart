import 'package:alumea/features/check-in/utils/mood_utils.dart';
import 'package:alumea/features/journey/domain/journey_entry.dart';
import 'package:alumea/features/journey/presentation/widgets/check_in_detail_dialog.dart';
import 'package:flutter/material.dart';

class CheckInCard extends StatelessWidget {
  const CheckInCard({super.key, required this.entry});
  final CheckInJourneyEntry entry;

  @override
  Widget build(BuildContext context) {
    final moodWord = moodWordFromRating(entry.checkInData.moodRating);

    return Hero(
      tag: 'check_in_card_${entry.checkInData.id}',
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CheckInDetailDialog(checkIn: entry.checkInData);
              },
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Card(
            elevation: 0.5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Check-in',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Feeling: $moodWord'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
