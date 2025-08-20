enum PathwayTaskType { textInput, journalPrompt, multiChoice }

class PathwayDay {
  final int dayNumber;
  final String title;
  final String audioScript; // The text for the 2-3 minute audio lesson
  final PathwayTaskType taskType;
  final String taskPrompt;
  final List<String>? taskOptions; // Only for multiChoice

  PathwayDay({
    required this.dayNumber,
    required this.title,
    required this.audioScript,
    required this.taskType,
    required this.taskPrompt,
    this.taskOptions,
  });
}