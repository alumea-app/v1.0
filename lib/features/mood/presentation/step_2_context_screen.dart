import 'package:alumea/features/mood/presentation/check_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<String> _contextTags = ['Work', 'Friends', 'Family', 'Partner', 'Health', 'Finances', 'Home', 'Nothing in particular'];

class Step2ContextScreen extends ConsumerWidget {
  final VoidCallback onSubmit;
  const Step2ContextScreen({Key? key, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the list of selected tags from our provider
    final selectedTags = ref.watch(checkInProvider).contextTags;
    final noteController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "What's contributing to this feeling?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Wrap allows the chips to flow to the next line
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.center,
            children: _contextTags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (bool selected) {
                  final currentTags = List<String>.from(ref.read(checkInProvider).contextTags);
                  if (selected) {
                    currentTags.add(tag);
                  } else {
                    currentTags.remove(tag);
                  }
                   ref.read(checkInProvider.notifier).state =
                      ref.read(checkInProvider).copyWith(contextTags: currentTags);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
           TextField(
            controller: noteController,
            decoration: const InputDecoration(
              hintText: 'Add a private note (optional)',
              border: OutlineInputBorder(),
            ),
             onChanged: (text){
                ref.read(checkInProvider.notifier).state =
                      ref.read(checkInProvider).copyWith(note: text);
             }
          ),
          const Spacer(), // Pushes the button to the bottom
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}