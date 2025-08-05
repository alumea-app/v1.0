import 'package:alumea/features/chat/application/chat_controller.dart';
import 'package:alumea/features/check-in/application/check_in_controller.dart';
import 'package:alumea/features/check-in/data/check_in_repository.dart';
import 'package:alumea/features/check-in/domain/check_in_model.dart';
import 'package:alumea/features/check-in/presentation/step_1_mood_screen.dart';
import 'package:alumea/features/check-in/presentation/step_2_context_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

final checkInControllerProvider =
    StateNotifierProvider<CheckInController, CheckInModel>((ref) {
  return CheckInController(ref.read(checkInRepositoryProvider));
});

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});
  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _pageController = PageController();

  // Add a flag to ensure the logic runs only once
  bool _didRunProactiveLumiMessage = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only run this logic once
    if (!_didRunProactiveLumiMessage) {
      final source = Routemaster.of(context).currentRoute.queryParameters['source'];
      if (source == 'checkin') {
        Future.delayed(const Duration(milliseconds: 1500), () {
          ref.read(chatControllerProvider.notifier).addProactiveLumiMessage();
        });
      }
      _didRunProactiveLumiMessage = true;
    }
  }

  void _submitCheckIn() async {
    final controller = ref.read(checkInControllerProvider.notifier);
    await controller.submitCheckIn();
    final moodRating = ref.read(checkInControllerProvider).moodRating;
    if (mounted) {
      Routemaster.of(context).replace('/check-in/reflection?mood=$moodRating');
    }
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Routemaster.of(context).pop(),
        ),
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