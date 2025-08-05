import 'package:alumea/core/app_theme.dart';
import 'package:alumea/features/check-in/presentation/check_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

const List<String> _contextTags = [
  'Work',
  'Friends',
  'Family',
  'Partner',
  'Health',
  'Finances',
  'Home',
  'Other',
];

class Step2ContextScreen extends ConsumerStatefulWidget {
  final VoidCallback onSubmit;
  const Step2ContextScreen({super.key, required this.onSubmit});

  @override
  _Step2ContextScreenState createState() => _Step2ContextScreenState();
}

class _Step2ContextScreenState extends ConsumerState<Step2ContextScreen> {
  // A state variable to control the "reveal" animation.
  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    // After a short delay, trigger the animation to start.
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _isRevealed = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final noteController = TextEditingController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Text(
            "What's contributing to this feeling?",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        // This is the main interactive area.
        Expanded(
          // LayoutBuilder gives us the exact dimensions of the area to calculate positions.
          child: LayoutBuilder(
            builder: (context, constraints) {
              final center = Offset(
                constraints.maxWidth / 2,
                constraints.maxHeight / 2,
              );
              final radius =
                  min(constraints.maxWidth, constraints.maxHeight) *
                  0.35; // 35% of the smallest dimension

              return Stack(
                alignment: Alignment.center,
                children: List.generate(_contextTags.length, (index) {
                  // Calculate the angle for each tag.
                  final angle = (2 * pi * index) / _contextTags.length;
                  // Calculate the final (x,y) position on the circle's edge.
                  final position = Offset(
                    radius * cos(angle),
                    radius * sin(angle),
                  );

                  // Use AnimatedPositioned for the beautiful radial animation.
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic,
                    // If not revealed, all tags are at the center. When revealed, they move to their calculated position.
                    // We need to adjust the position to be relative to the top-left corner for the `Positioned` widget.
                    top: _isRevealed
                        ? center.dy +
                              position.dy -
                              20 /* vertical offset for chip height */
                        : center.dy - 20,
                    left: _isRevealed
                        ? center.dx +
                              position.dx -
                              45 /* horizontal offset for chip width */
                        : center.dx - 45,
                    child: _PebbleChip(tag: _contextTags[index]),
                  );
                }),
              );
            },
          ),
        ),

        // --- Bottom Controls ---
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              _InvitationTextField(
                controller: noteController,
                onChanged: (text) {
                   ref.read(checkInControllerProvider.notifier).state =
                      ref.read(checkInControllerProvider).copyWith(note: text);
                }
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.onSubmit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PebbleChip extends ConsumerWidget {
  final String tag;
  const _PebbleChip({required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTags = ref.watch(checkInControllerProvider.select((s) => s.contextTags));
    final isSelected = selectedTags.contains(tag);

    return GestureDetector(
      onTap: () {
        final currentTags = List<String>.from(ref.read(checkInControllerProvider).contextTags);
        if (!isSelected) {
          currentTags.add(tag);
        } else {
          currentTags.remove(tag);
        }
        ref.read(checkInControllerProvider.notifier).state =
            ref.read(checkInControllerProvider).copyWith(contextTags: currentTags);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(24), // "Squircle" shape
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300,
            width: 1.5
          )
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppTheme.primaryBlue
          ),
        ),
      ),
    );
  }
}


class _InvitationTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const _InvitationTextField({required this.controller, required this.onChanged});
  
  @override
  Widget build(BuildContext context){
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 3,
      minLines: 1,
      decoration: InputDecoration(
        // Remove all borders
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        // The floating label is the modern style
        labelText: "Add a private note", 
        labelStyle: TextStyle(color: Colors.grey.shade600),
        // A subtle prefix icon
        prefixIcon: Icon(Icons.edit_outlined, color: Colors.grey.shade400, size: 20,),
        // Use the filled property to give it a very light background color
        // that separates it from the main screen background
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}