import 'package:chat_with_firebase/core/models/chat_notification.dart';
import 'package:flutter/material.dart';

class ChatNotificationService with ChangeNotifier {
  final List<ChatNotification> _items = [
    // ChatNotification(title: "title", body: "body")
  ];
  List<ChatNotification> get items => [..._items];
  int get itemCount => _items.length;
  void add(ChatNotification notification) {
    _items.add(notification);
    notifyListeners();
  }

  void remove(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
