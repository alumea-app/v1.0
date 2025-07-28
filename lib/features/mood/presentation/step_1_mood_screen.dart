import 'package:alumea/features/mood/presentation/check_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step1MoodScreen extends ConsumerWidget {
  final VoidCallback onNext;
  const Step1MoodScreen({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "How are you feeling right now?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          _MoodButton(
            label: 'Great',
            emoji: '😁',
            onPressed: () {
              ref.read(checkInProvider.notifier).state =
                  ref.read(checkInProvider).copyWith(moodRating: 5); // Assuming copyWith exists
              onNext();
            },
          ),
          _MoodButton(label: 'Good', emoji: '🙂', onPressed: () {
             ref.read(checkInProvider.notifier).state =
                  ref.read(checkInProvider).copyWith(moodRating: 4);
              onNext();
          }),
          _MoodButton(label: 'Okay', emoji: '😐', onPressed: () {
             ref.read(checkInProvider.notifier).state =
                  ref.read(checkInProvider).copyWith(moodRating: 3);
              onNext();
          }),
          _MoodButton(label: 'Bad', emoji: '😟', onPressed: () {
             ref.read(checkInProvider.notifier).state =
                  ref.read(checkInProvider).copyWith(moodRating: 2);
              onNext();
          }),
           _MoodButton(label: 'Awful', emoji: '😭', onPressed: () {
             ref.read(checkInProvider.notifier).state =
                  ref.read(checkInProvider).copyWith(moodRating: 1);
              onNext();
          }),
        ],
      ),
    );
  }
}

// Reusable button widget for this screen
class _MoodButton extends StatelessWidget {
  final String label;
  final String emoji;
  final VoidCallback onPressed;
  
  const _MoodButton({required this.label, required this.emoji, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// Add copyWith to your CheckInModel in `check_in_model.dart` for this to work
// extension CheckInModelX on CheckInModel {
//   CheckInModel copyWith({int? moodRating, List<String>? contextTags, String? note}) {
//     return CheckInModel(moodRating: moodRating ?? this.moodRating, ...);
//   }
// }