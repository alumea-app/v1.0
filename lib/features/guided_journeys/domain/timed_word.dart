class TimedWord {
  final String text;
  final Duration startTime;
  final Duration endTime;

  const TimedWord({
    required this.text,
    required this.startTime,
    required this.endTime,
  });
}

// A helper function to process the script.
// We'll assume an average reading speed of 150 words per minute.
List<TimedWord> parseScript(String script) {
  final words = script.split(' ');
  final timedWords = <TimedWord>[];
  // Milliseconds per word = 60,000 ms / 150 words
  const msPerWord = 700;

  for (int i = 0; i < words.length; i++) {
    timedWords.add(
      TimedWord(
        text: words[i],
        startTime: Duration(milliseconds: i * msPerWord),
        endTime: Duration(milliseconds: (i + 1) * msPerWord),
      ),
    );
  }
  return timedWords;
}
