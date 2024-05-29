import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessage {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await firebaseMessaging.requestPermission();
    final FCMtoken = await firebaseMessaging.getToken();
    if (FCMtoken != null) {
      debugPrint('Token: $FCMtoken');
    } else {
      debugPrint('Failed to get FCM token');
    }
    FirebaseMessaging.instance.getInitialMessage().then(handleNotification);
    FirebaseMessaging.onMessage.listen(handleNotification);
  }

  void handleNotification(RemoteMessage? message) {
    if (message == null) return;
    debugPrint('title: ${message.notification?.title.toString()}');
    debugPrint('body: ${message.notification?.body.toString()}');
  }
}
