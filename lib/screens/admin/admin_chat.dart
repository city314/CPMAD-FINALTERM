import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/message.dart';

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({super.key});

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Message> messages = [];
  bool isLoading = false;

  final String userId = "user_id_demo"; // TODO: Thay bằng user thực
  final String baseUrl = "http://localhost:3000"; // TODO: chỉnh lại nếu cần

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    setState(() => isLoading = true);
    try {
      final res = await http.get(Uri.parse('$baseUrl/api/support/$userId'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List rawMessages = data['messages'];
        setState(() {
          messages = rawMessages
              .map((m) => Message.fromJson(m as Map<String, dynamic>))
              .toList();
        });
        scrollToBottom();
      }
    } catch (e) {
      debugPrint('Lỗi tải tin nhắn: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> sendMessage({String? text, String? imageUrl}) async {
    if ((text == null || text.trim().isEmpty) && imageUrl == null) return;

    final message = Message(
      text: text ?? '[Hình ảnh]',
      isUser: true,
      time: DateTime.now(),
    );

    setState(() {
      messages.add(message);
      _controller.clear();
    });
    scrollToBottom();

    // Gửi về server
    await http.post(
      Uri.parse('$baseUrl/api/support/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'message': message.toJson(),
      }),
    );
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget buildBubble(Message msg) {
    return Align(
      alignment:
      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: msg.isUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(msg.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hỗ trợ khách hàng')),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (_, i) => buildBubble(messages[i]),
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {
                  // TODO: tích hợp chọn ảnh + upload sau này
                  sendMessage(imageUrl: 'mock_image_url.jpg');
                },
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (text) => sendMessage(text: text),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => sendMessage(text: _controller.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
