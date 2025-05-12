import 'dart:convert';
import 'package:cpmad_final/pattern/current_user.dart';
import 'package:cpmad_final/service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<CustomerSupportScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _picker = ImagePicker();
  final FocusNode _inputFocusNode = FocusNode();
  final currentUserRole = CurrentUser().role ?? 'admin';
  final userEmail = CurrentUser().email ?? 'admin@gmail.com';
  String? chatId;

  List<Map<String, dynamic>> _messages = [];

  void _sendMessage({String? text, String? imageBase64}) async {
    if ((text == null || text.trim().isEmpty) && imageBase64 == null) return;

    final messageData = {
      'text': text ?? '',
      'isUser': currentUserRole == 'user',
      'time': DateTime.now(),
      'image': imageBase64 ?? '',
    };

    setState(() {
      _messages.add(messageData);
    });

    _controller.clear();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    chatId = await UserService.sendMessage(
      userEmail: userEmail!,
      text: text ?? '',
      image: imageBase64 ?? '',
      isUser: currentUserRole == 'user',
    );

    if (chatId != null) {
      print("Chat ID: $chatId");
    } else {
      print("Error sending message");
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final base64Image = base64Encode(bytes);
      _sendMessage(imageBase64: base64Image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = const Color(0xFF3F51B5); // Indigo
    final Color accentColor = const Color(0xFFFFC107); // Amber
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: themeColor),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(userEmail!),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final data = _messages[index];
                final isMe = (data['isUser'] && currentUserRole == 'user') ||
                    (!data['isUser'] && currentUserRole == 'admin');
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? themeColor.withOpacity(0.85)
                          : (isDark ? Colors.grey[700] : Colors.grey[300]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: data['image'] != ''
                        ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.8,
                                maxHeight: MediaQuery.of(context).size.height * 0.8,
                              ),
                              child: Image.memory(
                                base64Decode(data['image']),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Image.memory(
                        base64Decode(data['image']),
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Text(
                      data['text'] ?? '',
                      style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: isDark ? Colors.grey[850] : Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image, color: accentColor),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: RawKeyboardListener(
                    focusNode: _inputFocusNode,
                    onKey: (event) {
                      if (event is RawKeyDownEvent) {
                        if (event.isShiftPressed && event.logicalKey == LogicalKeyboardKey.enter) {
                          final text = _controller.text;
                          final selection = _controller.selection;
                          final newText = text.replaceRange(selection.start, selection.end, '');
                          _controller.text = newText;
                          _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: selection.start),
                          );
                        } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                          // Chặn xuống dòng mặc định và gửi
                          _sendMessage(text: _controller.text.trim());
                          _controller.clear();
                          // Không cho xuống dòng
                          FocusScope.of(context).requestFocus(_inputFocusNode);
                        }
                      }
                    },
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: themeColor,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      _sendMessage(text: _controller.text.trim());
                      _controller.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
