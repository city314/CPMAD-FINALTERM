import 'message.dart';

class CustomerSupport {
  final String? id;
  final String userId;
  final List<Message> messages;
  final String sentBy; // 'admin' hoặc 'user'
  final DateTime timeSent;

  CustomerSupport({
    this.id,
    required this.userId,
    required this.messages,
    required this.sentBy,
    required this.timeSent,
  });

  factory CustomerSupport.fromJson(Map<String, dynamic> json) => CustomerSupport(
    id: json['_id'],
    userId: json['user_id'],
    messages: (json['messages'] as List<dynamic>)
        .map((m) => Message.fromJson(m as Map<String, dynamic>))
        .toList(),
    sentBy: json['sent_by'],
    timeSent: DateTime.parse(json['time_sent']),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'user_id': userId,
    'messages': messages.map((m) => m.toJson()).toList(),
    'sent_by': sentBy,
    'time_sent': timeSent.toIso8601String(),
  };
}
