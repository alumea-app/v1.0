import 'package:alumea/core/app_theme.dart';
import 'package:alumea/features/check-in/presentation/check_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step1MoodScreen extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  const Step1MoodScreen({super.key, required this.onNext});

  @override
  _Step1MoodScreenState createState() => _Step1MoodScreenState();
}

class _Step1MoodScreenState extends ConsumerState<Step1MoodScreen> {
  // A value from -1.0 (bottom) to 1.0 (top)
  double _dragValue = 0.0; 
  int _currentMood = 3; // 1-5, starts at "Okay"

  // Maps mood rating to its properties
  final Map<int, dynamic> _moodMap = {
    5: {'label': 'Great', 'emoji': '😁', 'color': AppTheme.secondaryLavender},
    4: {'label': 'Good', 'emoji': '🙂', 'color': AppTheme.accentGreen},
    3: {'label': 'Okay', 'emoji': '😐', 'color': AppTheme.primaryBlue},
    2: {'label': 'Bad', 'emoji': '😟', 'color': Colors.grey},
    1: {'label': 'Awful', 'emoji': '😭', 'color': AppTheme.textSecondary},
  };

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      // Update drag value based on vertical movement, clamped between -1 and 1
      _dragValue = (_dragValue - details.delta.dy / 100).clamp(-1.0, 1.0);
      
      // Convert drag value to a mood rating from 1 to 5
      _currentMood = (2 * _dragValue + 3).round().clamp(1, 5);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    // When drag ends, save the state and move to the next page
    ref.read(checkInControllerProvider.notifier).state =
        ref.read(checkInControllerProvider).copyWith(moodRating: _currentMood);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final moodData = _moodMap[_currentMood]!;
    final sphereSize = 150 + (_dragValue * 50);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "How are you feeling right now?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 60),
        Text(
          moodData['emoji'],
          style: TextStyle(fontSize: 40 + (_dragValue * 10)),
        ),
        const SizedBox(height: 10),
        Text(
          moodData['label'],
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: moodData['color'],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onVerticalDragUpdate: _onDragUpdate,
          onVerticalDragEnd: _onDragEnd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: sphereSize,
            height: sphereSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [moodData['color'].withOpacity(0.5), moodData['color']],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: moodData['color'].withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
          ),
        ),
        const Spacer(),
        const Text(
          'Drag the sphere up or down',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}