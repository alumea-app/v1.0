import 'package:equatable/equatable.dart';
class ChatMessage extends Equatable {
  final String text;
  final Sender sender;
  final DateTime? timestamp;

  const ChatMessage({
    required this.text,
    required this.sender,
    this.timestamp,
  });

  @override
  List<Object?> get props => [text, sender, timestamp];
}

enum Sender { lumi, user }