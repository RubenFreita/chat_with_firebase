import 'package:chat_with_firebase/core/services/auth/auth_service.dart';
import 'package:chat_with_firebase/page/chat_page.dart';
import 'package:chat_with_firebase/core/models/chat_user.dart';
import 'package:chat_with_firebase/page/auth_page.dart';
import 'package:chat_with_firebase/page/loading_page.dart';
import 'package:flutter/material.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatUser?>(
      stream: AuthService().userChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return snapshot.hasData
              ? ChatPage(
                  user: snapshot.data!,
                )
              : const AuthPage();
        }
      },
    );

    // return FutureBuilder(
    //   future: Firebase.initializeApp(),
    //   builder: (ctx, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       print("Futurebuilder");
    //       return Container();
    //       //return const LoadingPage();
    //     } else {

    //     }
    //   },
    // );
  }
}
