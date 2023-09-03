import 'package:chat_with_firebase/components/message_bubble.dart';
import 'package:chat_with_firebase/core/services/auth/auth_service.dart';
import 'package:chat_with_firebase/core/services/chat/chat_service.dart';
import 'package:chat_with_firebase/page/loading_page.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    return StreamBuilder(
      stream: ChatService().messageStream(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Sem Mensagens. Vamos Conversar?"));
        } else {
          final msgs = snapshot.data!;
          return ListView.builder(
            reverse: true,
            itemCount: msgs.length,
            itemBuilder: (contexto, index) {
              return MessageBubble(
                message: msgs[index],
                belongsToCurrentUser: msgs[index].userId == currentUser!.id,
              );
            },
          );
        }
      },
    );
  }
}
