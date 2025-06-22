import 'package:alumea/features/auth/presentation/widgets/registration_form.dart';
import 'package:alumea/features/chat/presentation/widgets/message_bubble.dart';
import 'package:alumea/features/chat/presentation/widgets/message_input_bar.dart';
import 'package:alumea/features/onboarding/application/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingChatScreen extends ConsumerWidget {
  const OnboardingChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    // Listen for the state change to show the registration sheet
    ref.listen<OnboardingState>(onboardingControllerProvider, (previous, next) {
      if (next.stage == OnboardingStage.promptingRegistration) {
        // Prevent showing multiple bottom sheets
        if (ModalRoute.of(context)?.isCurrent != true) {
             Navigator.of(context).pop();
        }
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          // You may want to prevent it from being dismissed by swiping down
          isDismissible: false, 
          enableDrag: false,
          builder: (ctx) => Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const RegistrationForm(),
            ),
        );
      }
    });

    final onboardingState = ref.watch(onboardingControllerProvider);
    
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: onboardingState.messages.length,
              itemBuilder: (context, index) {
                // Here we correctly use the MessageBubble widget
                return MessageBubble(message: onboardingState.messages[index]);
              },
            ),
          ),
          MessageInputBar(
            controller: controller,
            // CORRECTLY calls ITS OWN controller
            onSend: () {
              ref.read(onboardingControllerProvider.notifier).submitMessage(controller.text);
              controller.clear();
            },
          ),
        ],
      ),
    );
  }
}