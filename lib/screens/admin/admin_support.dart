import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessengerLikeChatListScreen extends StatelessWidget {
  const MessengerLikeChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Đoạn chat', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz, color: Colors.black54), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final chat = chatList[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(chat.avatarUrl),
                ),
              ],
            ),
            title: Text(chat.customerEmail, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              chat.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: Text(
              DateFormat('HH:mm').format(chat.lastMessageTime),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              // Điều hướng tới chi tiết chat
            },
          );
        },
      ),
    );
  }
}

class ChatOverview {
  final String customerEmail;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String avatarUrl;

  ChatOverview({
    required this.customerEmail,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatarUrl,
  });
}

// Mock data
final chatList = [
  ChatOverview(
    customerEmail: 'tram123@gmail.com',
    lastMessage: 'Đưa sách cho em',
    lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
    avatarUrl: 'https://example.com/avatar1.jpg',
  ),
  ChatOverview(
    customerEmail: 'vietphat@gmail.com',
    lastMessage: 'Kinh tế ổn định chưa?',
    lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
    avatarUrl: 'https://example.com/avatar2.jpg',
  ),
  ChatOverview(
    customerEmail: 'loc123@gmail.com',
    lastMessage: 'Bạn: Okok',
    lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
    avatarUrl: 'https://example.com/avatar3.jpg',
  ),
];
