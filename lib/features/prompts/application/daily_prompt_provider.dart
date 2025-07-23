import 'package:alumea/features/prompts/data/prompt_repository.dart';
import 'package:alumea/features/prompts/domain/prompt_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_prompt_provider.g.dart';

@riverpod
Future<PromptModel?> dailyPrompt(Ref ref) async {
  // Fetch all available prompts from the repository.
  final allPrompts = await ref.watch(promptRepositoryProvider).getAllPrompts();

  if (allPrompts.isEmpty) {
    return null;
  }

  // This is a simple but effective algorithm to get a different prompt each day.
  // It uses the day of the year to create a consistent index for the entire day.
  final dayOfYear = DateTime.now().day;
  final index = dayOfYear % allPrompts.length;

  return allPrompts[index];
}