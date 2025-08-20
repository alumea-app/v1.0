import 'package:alumea/features/check-in/domain/check_in_model.dart';
import 'package:alumea/features/check-in/utils/mood_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckInDetailDialog extends StatelessWidget {
  final CheckInModel checkIn;

  const CheckInDetailDialog({super.key, required this.checkIn});

  @override
  Widget build(BuildContext context) {
    final moodWord = moodWordFromRating(checkIn.moodRating);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      title: Hero(
        tag: 'check_in_card_${checkIn.id}',
        child: Row(
          children: [
            moodIconFromRating(checkIn.moodRating),
            const SizedBox(width: 8),
            const Text('Daily Check-in'),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'On ${DateFormat.yMMMMd().format(checkIn.timestamp)}, you felt:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            Text(
              moodWord,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('ACTIVITIES', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            if (checkIn.activities.isNotEmpty) ...[
              Wrap(
                spacing: 8.0,
                children: checkIn.activities
                    .map((activity) => Chip(label: Text(activity)))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ] else ...{
              const Text('No activities recorded.'),
              const SizedBox(height: 16),
            },
            Text('NOTE', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            if (checkIn.note!.isNotEmpty) ...[
              Text(checkIn.note!),
            ] else ...{
              const Text('No note recorded.'),
              const SizedBox(height: 16),
            },
          ],
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
