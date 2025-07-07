import 'dart:async';
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:alumea/features/onboarding/data/onboarding_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_controller.g.dart';

enum OnboardingStage {
  initial,
  askingForName,
  askingFirstThought,
  promptingAuthChoice,
  registrationComplete,
}

class OnboardingState {
  final OnboardingStage stage;
  final List<ChatMessage> messages;
  final String userName;

  OnboardingState({
    required this.stage,
    this.messages = const [],
    this.userName = '',
  });

  OnboardingState copyWith({
    OnboardingStage? stage,
    List<ChatMessage>? messages,
    String? userName,
  }) {
    return OnboardingState(
      stage: stage ?? this.stage,
      messages: messages ?? this.messages,
      userName: userName ?? this.userName,
    );
  }
}

// --- The Controller ---

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingState build() {
    _startOnboardingSequence();
    return OnboardingState(stage: OnboardingStage.initial);
  }

  void _startOnboardingSequence() async {
    await _addDelayedMessage(
        "Hi there. I'm Lumi, your companion here at Alumea.",
        stage: OnboardingStage.askingForName,
        delayMs: 500);
    await _addDelayedMessage("To get started, what should I call you?",
        stage: OnboardingStage.askingForName, delayMs: 1500);
  }

  void submitMessage(String text) async {
    final currentStage = state.stage;

    if (currentStage == OnboardingStage.askingForName) {
      final updatedUserName = text;
      // Wait for sharedPreferencesProvider to be ready before saving
      final sharedPrefsAsync = ref.read(sharedPreferencesProvider);
      if (sharedPrefsAsync is AsyncData<SharedPreferences>) {
        final repo = OnboardingRepository(sharedPrefsAsync.value);
        await repo.saveUserName(updatedUserName);
        // Only update state after saving userName
        state = state.copyWith(
          messages: [
            ...state.messages,
            ChatMessage(text: text, sender: Sender.user)
          ],
          userName: updatedUserName,
        );
      } else {
        // If not ready, retry after a short delay
        await Future.delayed(const Duration(milliseconds: 100));
        submitMessage(text);
        return;
      }
      // Send Lumi's first two messages without changing the stage
      await _addDelayedMessage("It's nice to meet you, $updatedUserName.",
          stage: OnboardingStage.askingForName, delayMs: 800);
      await _addDelayedMessage(
          "I want to reassure you that this is a safe space. Everything you share here is private and secure.",
          stage: OnboardingStage.askingForName,
          delayMs: 1800);
      // Only after the last message, change the stage to askingFirstThought
      await _addDelayedMessage("Now, what's on your mind right now?",
          stage: OnboardingStage.askingFirstThought, delayMs: 1500);
    } else if (currentStage == OnboardingStage.askingFirstThought) {
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(text: text, sender: Sender.user)
        ],
      );

      await _addDelayedMessage(
          "Thank you for sharing that with me. It takes courage to write that down.",
          stage: OnboardingStage.promptingAuthChoice,
          delayMs: 1200);
      await _addDelayedMessage(
          "To make sure we can save this thought and all of our future conversations securely, let's create your private account.",
          stage: OnboardingStage.promptingAuthChoice,
          delayMs: 1800);
    }
  }

  Future<void> _addDelayedMessage(String text,
      {required OnboardingStage stage, required int delayMs}) async {
    await Future.delayed(Duration(milliseconds: delayMs));

    // Use a try-catch block to safely update the state.
    try {
      state = state.copyWith(
        stage: stage,
        messages: [
          ...state.messages,
          ChatMessage(text: text, sender: Sender.lumi)
        ],
      );
    } catch (e) {
      // This error is expected if the provider is disposed before the future completes.
      // We can safely ignore it.
      print('Notifier was disposed. State update for "$text" was ignored.');
    }
  }
}
