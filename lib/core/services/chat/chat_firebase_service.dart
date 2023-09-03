import 'dart:async';
import 'package:chat_with_firebase/core/models/chat_message.dart';
import 'package:chat_with_firebase/core/models/chat_user.dart';
import 'package:chat_with_firebase/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messageStream() {
    final store = FirebaseFirestore.instance;
    final snaphots = store
        .collection("chat")
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .orderBy('createAt', descending: true)
        .snapshots();

    return snaphots.map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return doc.data();
          },
        ).toList();
      },
    );

    // return Stream<List<ChatMessage>>.multi(
    //   (controller) {
    //     snaphots.listen(
    //       (snapshot) {
    //         List<ChatMessage> lista = snapshot.docs.map((doc) {
    //           return doc.data();
    //         }).toList();
    //         controller.add(lista);
    //       },
    //     );
    //   },
    // );
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final msg = ChatMessage(
      id: "",
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageURL,
    );
    // ChatMessage => Map<Strinf, dunamic>
    final docRef = await store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .add(msg);
    final doc = await docRef.get();
    return doc.data()!;
    // Map<Strinf, dunamic> => ChatMessage
  }

  // .withConverter(fromFirestore: fromFirestore, toFirestore: toFirestore).

  ChatMessage _fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    return ChatMessage(
      id: doc.id,
      text: doc["text"],
      createdAt: DateTime.parse(doc['createAt']),
      userId: doc['userId'],
      userName: doc['userName'],
      userImageURL: doc['userImageURL'],
    );
  }

  Map<String, dynamic> _toFirestore(ChatMessage msg, SetOptions? options) {
    return {
      'text': msg.text,
      'createAt': msg.createdAt.toIso8601String(),
      'userId': msg.userId,
      'userName': msg.userName,
      'userImageURL': msg.userImageURL,
    };
  }
}
