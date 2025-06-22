import 'dart:async';
import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

// --- State Definition ---
enum OnboardingStage {
  initial,
  askingForName,
  askingFirstThought,
  promptingRegistration
}

class OnboardingState {
  final OnboardingStage stage;
  final List<ChatMessage> messages;

  OnboardingState({required this.stage, this.messages = const []});

  OnboardingState copyWith(
      {OnboardingStage? stage, List<ChatMessage>? messages}) {
    return OnboardingState(
      stage: stage ?? this.stage,
      messages: messages ?? this.messages,
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

  void _startOnboardingSequence() {
    _addDelayedMessage("Hi there. I'm Lumi, your companion here at Alumea.",
        stage: OnboardingStage.askingForName, delayMs: 500);
    _addDelayedMessage("To get started, what should I call you?",
        stage: OnboardingStage.askingForName, delayMs: 1500);
  }

  void submitMessage(String text) {
    final currentStage = state.stage;

    state = state.copyWith(messages: [
      ...state.messages,
      ChatMessage(text: text, sender: Sender.user)
    ]);

    if (currentStage == OnboardingStage.askingForName) {
      _addDelayedMessage("What's on your mind right now?",
          stage: OnboardingStage.askingFirstThought, delayMs: 500);
    } else if (currentStage == OnboardingStage.askingFirstThought) {
      _addDelayedMessage(
          "Thank you for sharing that with me. It takes courage to write that down.",
          stage: OnboardingStage.promptingRegistration,
          delayMs: 1200);
      _addDelayedMessage(
          "To make sure we can save this thought and all of our future conversations securely, let's create your private account.",
          stage: OnboardingStage.promptingRegistration,
          delayMs: 3000);
    }
  }

  // A helper function to add Lumi's messages with a delay
  void _addDelayedMessage(String text,
      {required OnboardingStage stage, required int delayMs}) {
    Future.delayed(Duration(milliseconds: delayMs), () {
      // THE FIX: The `mounted` check is removed. Riverpod handles provider lifecycle.
      state = state.copyWith(stage: stage, messages: [
        ...state.messages,
        ChatMessage(text: text, sender: Sender.lumi)
      ]);
    });
  }
}
