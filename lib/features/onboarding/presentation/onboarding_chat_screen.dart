import 'package:alumea/features/auth/presentation/widgets/registration_form.dart';
import 'package:alumea/features/chat/presentation/widgets/message_bubble.dart';
import 'package:alumea/features/chat/presentation/widgets/message_input_bar.dart';
import 'package:alumea/features/onboarding/application/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

// 1. Convert the widget to a ConsumerStatefulWidget
class OnboardingChatScreen extends ConsumerStatefulWidget {
  const OnboardingChatScreen({super.key});

  @override
  // 2. The createState method is now required
  ConsumerState<OnboardingChatScreen> createState() =>
      _OnboardingChatScreenState();
}

// 3. Create the accompanying State class
class _OnboardingChatScreenState extends ConsumerState<OnboardingChatScreen> {
  // 4. Declare the controller here. It will persist across builds.
  late final TextEditingController _textController;
  bool _showAuthChoice = false;
  OnboardingStage? _lastStage;

  @override
  void initState() {
    super.initState();
    // 5. Initialize the controller once when the widget is first created.
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    // 6. It's crucial to dispose of the controller to prevent memory leaks.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We no longer create the controller here. We just watch the state.
    final onboardingState = ref.watch(onboardingControllerProvider);

    // Add delay before showing auth choice when stage changes to promptingAuthChoice
    if (onboardingState.stage == OnboardingStage.promptingAuthChoice &&
        _lastStage != OnboardingStage.promptingAuthChoice &&
        !_showAuthChoice) {
      _lastStage = OnboardingStage.promptingAuthChoice;
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _showAuthChoice = true);
      });
    } else if (onboardingState.stage != OnboardingStage.promptingAuthChoice &&
        _showAuthChoice) {
      _showAuthChoice = false;
      _lastStage = onboardingState.stage;
    } else {
      _lastStage = onboardingState.stage;
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: onboardingState.messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child:
                      MessageBubble(message: onboardingState.messages[index]),
                );
              },
            ),
          ),
          if (_showAuthChoice)
            const _AuthChoiceButtons(), // Use const for stateless widgets

          if (onboardingState.stage != OnboardingStage.promptingAuthChoice)
            MessageInputBar(
              // 7. Use our persistent _textController
              controller: _textController,
              onSend: () {
                if (_textController.text.trim().isNotEmpty) {
                  ref
                      .read(onboardingControllerProvider.notifier)
                      .submitMessage(_textController.text.trim());
                  _textController.clear();
                  FocusScope.of(context).unfocus(); // Hide the keyboard
                }
              },
            ),
        ],
      ),
    );
  }
}

// This widget can remain a stateless ConsumerWidget since it has no lifecycle to manage.
class _AuthChoiceButtons extends ConsumerWidget {
  const _AuthChoiceButtons(); // Use const constructor

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                enableDrag: false,
                builder: (ctx) => const RegistrationForm(),
              );
            },
            child: const Text('Create My Private Account'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Routemaster.of(context).push('/login');
            },
            child: const Text('I Already Have an Account'),
          )
        ],
      ),
    );
  }
}
