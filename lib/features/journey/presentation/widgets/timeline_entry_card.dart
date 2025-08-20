// // lib/features/journey/presentation/widgets/timeline_entry_widget.dart
// import 'package:alumea/features/chat/presentation/widgets/date_separator.dart';
// import 'package:alumea/features/journey/domain/journey_entry.dart';
// import 'package:alumea/features/journey/presentation/widgets/timeline_node.dart';
// import 'package:flutter/material.dart';

// // Import your card widgets (which we will create next)

// class TimelineEntryWidget extends StatelessWidget {
//   final JourneyEntry entry;
//   final bool isLeftAligned;

//   const TimelineEntryWidget({
//     super.key,
//     required this.entry,
//     this.isLeftAligned = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // This widget acts as a dispatcher. Based on the entry type,
//     // it returns the correct card wrapped in the timeline layout.

//     final Widget contentCard = _buildContentCard();

//     // For headers and separators, we don't need the dual-axis layout.
//     if (entry.type == EntryType.header ||
//         entry.type == EntryType.dateSeparator) {
//       return contentCard;
//     }

//     return IntrinsicHeight(
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           if (!isLeftAligned) const Spacer(),
//           Expanded(flex: 5, child: contentCard),
//           // We will create the TimelineNode painter in a separate file for cleanliness.
//           TimelineNode(),
//           if (isLeftAligned) const Spacer(),
//         ],
//       ),
//     );
//   }

//   Widget _buildContentCard() {
//     switch (entry.type) {
//       case EntryType.header:
//         return HeaderCard(title: entry.title!);
//       case EntryType.dateSeparator:
//         return DateSeparator(
//           date: entry.timestamp,
//         ); // Simple private widget
//       case EntryType.checkIn:
//         return CheckInCard(title: entry.title!, tags: entry.tags ?? []);
//       case EntryType.chat:
//         // TODO: Create a ChatCard widget
//         return Card(
//           child: ListTile(
//             title: Text(entry.title!),
//             subtitle: Text(entry.content!),
//           ),
//         );
//       case EntryType.tool:
//         // TODO: Create a ToolCard widget
//         return Card(
//           child: ListTile(
//             title: Text(entry.title!),
//             subtitle: Text(entry.content!),
//           ),
//         );
//       default:
//         return const SizedBox.shrink();
//     }
//   }
// }

// class CheckInCard extends StatelessWidget {
//   final String title;
//   final List<String> tags;
//   const CheckInCard({super.key, required this.title, required this.tags});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(title: Text(title), subtitle: Text(tags.join(', '))),
//     );
//   }
// }

// class HeaderCard extends StatelessWidget {
//   final String title;
//   const HeaderCard({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Card(child: ListTile(title: Text(title)));
//   }
// }

// // TODO: Create _TimelineNode in its own file (similar to previous example with CustomPainter).
// // TODO: Create _DateSeparator here or in its own file.
