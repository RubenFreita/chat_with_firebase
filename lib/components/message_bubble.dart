import 'dart:io';

import 'package:chat_with_firebase/core/models/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.belongsToCurrentUser,
  });
  final bool belongsToCurrentUser;
  final ChatMessage message;

  Widget _showUserImage(String imagePath, BuildContext context) {
    ImageProvider? imageProvider;
    final uri = Uri.parse(imagePath);
    if (uri.path.contains("assets")) {
      imageProvider = const AssetImage("assets\\images\\avatar.png");
    } else if (uri.scheme.contains('http')) {
      imageProvider = NetworkImage(uri.toString());
    } else {
      imageProvider = FileImage(File(uri.toString()));
    }

    return Positioned(
      right: belongsToCurrentUser ? 5 : null,
      left: belongsToCurrentUser ? null : 8,
      top: !belongsToCurrentUser ? 3 : null,
      child: CircleAvatar(
        backgroundImage: imageProvider,
        backgroundColor: belongsToCurrentUser
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: belongsToCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              width: 180,
              margin: EdgeInsets.only(
                left: 20,
                right: 10,
                bottom: belongsToCurrentUser ? 2 : 10,
                top: belongsToCurrentUser ? 2 : 20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                color: belongsToCurrentUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: belongsToCurrentUser
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: belongsToCurrentUser
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (!belongsToCurrentUser)
                        Text(
                          message.userName.length > 10 &&
                                  !message.userName.contains(" ")
                              ? "${message.userName[0].toUpperCase()}${message.userName.substring(1, 10).toLowerCase()}..."
                              : "${message.userName.split(" ")[0][0].toUpperCase()}${message.userName.split(" ")[0].substring(1).toLowerCase()}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    ],
                  ),
                  Text(
                    message.text,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!belongsToCurrentUser)
          Positioned(
            right: belongsToCurrentUser ? 5 : null,
            left: belongsToCurrentUser ? null : 5,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: belongsToCurrentUser
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
        if (!belongsToCurrentUser)
          _showUserImage(message.userImageURL, context),
      ],
    );
  }
}
