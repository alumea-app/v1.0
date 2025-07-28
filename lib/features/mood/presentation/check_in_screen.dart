import 'package:alumea/features/mood/domain/check_in_model.dart';
import 'package:alumea/features/mood/presentation/step_1_mood_screen.dart';
import 'package:alumea/features/mood/presentation/step_2_context_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

// A simple StateProvider to hold our in-progress check-in data.
final checkInProvider = StateProvider.autoDispose<CheckInModel>((ref) {
  return CheckInModel(moodRating: 0, contextTags: [], timestamp: DateTime.now());
});

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);
  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _pageController = PageController();

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _submitCheckIn() {
    final checkInData = ref.read(checkInProvider);
    print("SUBMITTING CHECK-IN: Mood = ${checkInData.moodRating}, Tags = ${checkInData.contextTags}, Note = ${checkInData.note}");
    // TODO: Call your repository here to save the checkInData to Firestore.
    
    // Navigate back home after submission.
    Routemaster.of(context).pop();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-in'),
      ),
      body: PageView(
        controller: _pageController,
        // Prevent the user from swiping between pages themselves.
        physics: const NeverScrollableScrollPhysics(), 
        children: [
          Step1MoodScreen(onNext: _nextPage),
          Step2ContextScreen(onSubmit: _submitCheckIn),
        ],
      ),
    );
  }
}