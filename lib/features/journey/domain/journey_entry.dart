import 'package:alumea/features/chat/domain/chat_message.dart';
import 'package:alumea/features/check-in/domain/check_in_model.dart';
import 'package:equatable/equatable.dart';

// An abstract base class for any entry that can appear on the journey screen.
abstract class JourneyEntry extends Equatable {
  final DateTime timestamp;

  const JourneyEntry({required this.timestamp});

  @override
  List<Object?> get props => [timestamp];
}

// A specific type of JourneyEntry for Daily Check-ins.
class CheckInJourneyEntry extends JourneyEntry {
  final CheckInModel checkInData;

  CheckInJourneyEntry({required this.checkInData})
    : super(timestamp: checkInData.timestamp);

  @override
  List<Object?> get props => [super.props, checkInData];
}


class ConversationJourneyEntry extends JourneyEntry {
  // Change this to hold the full list of messages for the day
  final List<ChatMessage> messages;

  const ConversationJourneyEntry({
    required this.messages,
    required super.timestamp,
  });

  @override
  List<Object?> get props => [super.props, messages];
}

