import 'dart:io';

import 'package:chat_with_firebase/components/messages.dart';
import 'package:chat_with_firebase/components/new_message.dart';
import 'package:chat_with_firebase/core/models/chat_user.dart';
import 'package:chat_with_firebase/core/services/auth/auth_service.dart';
import 'package:chat_with_firebase/core/services/notification/chat_notification_service.dart';
import 'package:chat_with_firebase/page/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    final String pathImage = user.imageURL;
    ImageProvider? imageProvider;
    final uri = Uri.parse(pathImage);
    if (uri.path.contains("assets")) {
      imageProvider = const AssetImage("assets\\images\\avatar.png");
    } else if (uri.scheme.contains('http')) {
      imageProvider = NetworkImage(uri.toString());
    } else {
      imageProvider = FileImage(File(uri.toString()));
    }
    final provider = Provider.of<ChatNotificationService>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: imageProvider,
              ),
              const SizedBox(width: 10),
              Text(
                user.name.length > 10 && !user.name.contains(" ")
                    ? "Olá, ${user.name[0].toUpperCase()}${user.name.substring(1, 10).toLowerCase()}..."
                    : "Olá, ${user.name.split(" ")[0][0].toUpperCase()}${user.name.split(" ")[0].substring(1).toLowerCase()}",
                style: TextStyle(
                    color: Theme.of(context)
                        .primaryTextTheme
                        .headlineMedium
                        ?.color),
              )
            ],
          ),
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton(
                  focusColor: Theme.of(context).primaryColor,
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "logout",
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                          ),
                          SizedBox(width: 10),
                          Text("Sair"),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == "logout") {
                      AuthService().logout();
                    }
                  }),
            ),
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return const NotificationPage();
                      }),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
                if (provider.itemCount != 0)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red.shade800,
                      //maxRadius: 8,
                      child: Text(
                        "${provider.itemCount}",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  )
              ],
            )
          ],
        ),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Messages()),
                NewMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
