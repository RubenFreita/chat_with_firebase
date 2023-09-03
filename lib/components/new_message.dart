import 'package:chat_with_firebase/core/services/auth/auth_service.dart';
import 'package:chat_with_firebase/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _message = '';
  final _messageController = TextEditingController();
  Future<void> _sendMessage() async {
    final user = AuthService().currentUser;
    if (user != null) {
      await ChatService().save(_message, user);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onSubmitted: (_) {
              if (_message.trim().isNotEmpty) {
                _sendMessage();
              }
            },
            onChanged: (msg) {
              setState(() {
                _message = msg;
              });
            },
            controller: _messageController,
            decoration: const InputDecoration(
              //border: InputBorder(borderSide: BorderSide.none),
              label: Text(
                "Escreva uma mesangem...",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
            icon: Icon(
              Icons.send,
              color: _message.trim().isEmpty ? null : Colors.blue,
            ))
      ],
    );
  }
}
