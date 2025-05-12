class Message {
  final String text;
  final bool isUser;
  final DateTime time;

  Message({
    required this.text,
    required this.isUser,
    required this.time,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    text: json['text'] ?? '',
    isUser: json['isUser'] ?? false,
    time: DateTime.parse(json['time']),
  );

  Map<String, dynamic> toJson() => {
    'text': text,
    'isUser': isUser,
    'time': time.toIso8601String(),
  };
}
