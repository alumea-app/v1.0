import 'package:alumea/features/guided_journeys/application/audio_player_service.dart';
import 'package:alumea/features/guided_journeys/application/journey_detail_provider.dart';
import 'package:alumea/features/guided_journeys/domain/guided_journey_model.dart';
import 'package:alumea/features/guided_journeys/domain/journey_step_model.dart';
import 'package:alumea/features/guided_journeys/domain/timed_word.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JourneyDetailScreen extends ConsumerWidget {
  final GuidedJourney journey;

  const JourneyDetailScreen({super.key, required this.journey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch our new provider to get the steps for this specific journey
    final stepsAsync = ref.watch(journeyStepsProvider(journey.id));

    return Scaffold(
      appBar: AppBar(title: Text(journey.title)),
      body: stepsAsync.when(
        data: (steps) {
          if (steps.isEmpty) {
            return const Center(
              child: Text('The steps for this journey will appear here.'),
            );
          }
          return PageView.builder(
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              return _JourneyStepView(step: step);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

// A private widget to display the content for a single day/step
class _JourneyStepView extends ConsumerStatefulWidget {
  final JourneyStep step;
  const _JourneyStepView({required this.step});

  @override
  ConsumerState<_JourneyStepView> createState() => _JourneyStepViewState();
}

class _JourneyStepViewState extends ConsumerState<_JourneyStepView> {
  late final AudioPlayerService _audioPlayerService;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  late final List<TimedWord> _transcript;
  int _currentWordIndex = -1;

  @override
  void initState() {
    super.initState();
    _audioPlayerService = ref.read(audioPlayerServiceProvider);

    _transcript = parseScript(widget.step.audioScript);

    // Listen to player state changes
    _audioPlayerService.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });
    _audioPlayerService.onDurationChanged.listen((duration) {
      if (mounted) setState(() => _duration = duration);
    });

    _audioPlayerService.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
          // Find the index of the word that should be highlighted
          _currentWordIndex = _transcript.indexWhere(
            (word) => position >= word.startTime && position < word.endTime,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    // Stop the audio when the widget is disposed
    _audioPlayerService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    final isPlaying = _playerState == PlayerState.playing;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAY ${step.day}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(step.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          // Placeholder for the audio lesson
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill_outlined,
                      ),
                      iconSize: 48,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        if (isPlaying) {
                          _audioPlayerService.pause();
                        } else {
                          // Play the specific audio file for this step
                          _audioPlayerService.play(step.audioAssetPath);
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Play Audio Lesson',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble().clamp(
                    0.0,
                    _duration.inSeconds.toDouble(),
                  ),
                  onChanged: (value) {
                    final position = Duration(seconds: value.toInt());
                    _audioPlayerService.seek(position);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position)),
                      Text(_formatDuration(_duration)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _TranscriptView(
            transcript: _transcript,
            currentWordIndex: _currentWordIndex,
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),
          // Dynamically build the task widget based on the step's taskType
          _buildTaskWidget(step),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  // This is the magic: it returns a different widget based on the task type
  Widget _buildTaskWidget(JourneyStep step) {
    switch (step.taskType) {
      case JourneyTaskType.textInput:
      case JourneyTaskType.journalPrompt:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (step.taskPrompt != null)
              Text(
                step.taskPrompt!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Type your answer here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 5,
            ),
          ],
        );
      case JourneyTaskType.multiChoice:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (step.taskPrompt != null)
              Text(
                step.taskPrompt!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 8),
            ...(step.taskChoices ?? []).map(
              (choice) => RadioListTile(
                title: Text(choice),
                value: choice,
                groupValue: null, // This would be managed by a state controller
                onChanged: (value) {
                  // TODO: Handle selection
                },
              ),
            ),
          ],
        );
      case JourneyTaskType.breathingExercise:
        return Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.air),
            label: const Text('Begin Exercise'),
            onPressed: () {
              // TODO: Launch breathing exercise UI
            },
          ),
        );
    }
  }
}

class _TranscriptView extends StatelessWidget {
  const _TranscriptView({
    required this.transcript,
    required this.currentWordIndex,
  });

  final List<TimedWord> transcript;
  final int currentWordIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: DefaultTextStyle.of(
            context,
          ).style.copyWith(fontSize: 18, height: 1.5),
          children: List.generate(transcript.length, (index) {
            final word = transcript[index];
            return TextSpan(
              text: '${word.text} ',
              // Highlight the current word
              style: TextStyle(
                color: index == currentWordIndex
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black54,
                fontWeight: index == currentWordIndex
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            );
          }),
        ),
      ),
    );
  }
}
