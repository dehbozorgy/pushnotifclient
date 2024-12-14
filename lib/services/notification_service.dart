
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../Component/ShowNotif.dart';
import '../Notification.dart';
import '../main.dart';
import '/Funcs.dart';

class NotificationService {

  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final _messaing = FirebaseMessaging.instance;

  Future<void> setupMessageHandlers() async {

    // foreground message
    FirebaseMessaging.onMessage.listen((message) async {

      Map<String,dynamic> data = message.data;

      String StrId = data.toString();

      int id = StrId.hashCode;

      // NotificationApi.showNotification(
      //   id: id,
      //     title: 'Title => ${data['title']}',
      //     body: 'Body => ${data['body']}',
      //     payload: '${data['title']}');

      String payload = data['title'];

      String? _actionId = await showMessageBox(navigatorkey.currentContext!, ShowNotif(
          title: data['title'],
          body: data['body'],
          payload: payload
      ));

      String _actionResult = " actionId => ";

      if(_actionId!=null)
        _actionResult += _actionId;
      else
        _actionResult += "Null";

      print(_actionResult);

      NotificationApi.onNotifications.add('${payload} ;  ${_actionResult}');


    });

    // backGround message
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // openes app
    final initialMessage = await _messaing.getInitialMessage();
    if(initialMessage != null){
      _handleBackgroundMessage(initialMessage);
    }

  }

  void _handleBackgroundMessage(RemoteMessage message) async {}

}