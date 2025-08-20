import 'package:flutter/material.dart';

// Assuming a 1-5 rating scale. We can adjust this as needed.
// 1: Sad, 2: Anxious, 3: Calm, 4: Happy, 5: Excited

String moodWordFromRating(int rating) {
  switch (rating) {
    case 1:
      return 'Sad';
    case 2:
      return 'Anxious';
    case 3:
      return 'Calm';
    case 4:
      return 'Happy';
    case 5:
      return 'Excited';
    default:
      return 'Neutral';
  }
}

Widget moodIconFromRating(int rating) {
  switch (rating) {
    case 1:
      return const Icon(Icons.sentiment_very_dissatisfied, color: Colors.grey);
    case 2:
      return const Icon(Icons.sentiment_neutral, color: Colors.orange);
    case 3:
      return const Icon(Icons.sentiment_satisfied, color: Colors.blue);
    case 4:
      return const Icon(Icons.sentiment_very_satisfied, color: Colors.green);
    case 5:
      return const Icon(Icons.celebration, color: Colors.purple);
    default:
      return const Icon(Icons.sentiment_satisfied, color: Colors.grey);
  }
}