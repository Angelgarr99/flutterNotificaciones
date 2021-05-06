import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:programar_notifi/constants.dart';
import 'package:programar_notifi/model/notificacion_model.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channel_id = "123";

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    tz.initializeTimeZones();
  }

  Future selectNotification(String payload) async {
    NotificacionModel notificacionModel =
        getNotificacionModelFromPayload(payload);
    cancelNotificationDateTime(notificacionModel);
    scheduleNotificationForDatetime(notificacionModel,
        "proximo recordatorio '${notificacionModel.texto}'!");
  }

  void showNotification(
      NotificacionModel notificacionModel, String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
        notificacionModel.hashCode,
        applicationName,
        notificationMessage,
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, applicationName,
                'Para recordarte los próximos cumpleaños.')),
        payload: jsonEncode(notificacionModel));
  }

  void scheduleNotificationForDatetime(
      NotificacionModel notificacionModel, String notificationMessage) async {
    DateTime now = DateTime.now();
    DateTime datetime = notificacionModel.dateTime;
    Duration difference = now.isAfter(datetime)
        ? now.difference(datetime)
        : datetime.difference(now);
    print(difference.inMinutes);
    _wasApplicationLaunchedFromNotification()
        .then((bool didApplicationLaunchFromNotification) => {
              if (!didApplicationLaunchFromNotification &&
                  difference.inMinutes <= 1)
                {showNotification(notificacionModel, notificationMessage)}
            });

    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificacionModel.hashCode,
        applicationName,
        notificationMessage,
        tz.TZDateTime.now(tz.local).add(difference),
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, applicationName,
                'Para recordarte los próximos cumpleaños')),
        payload: jsonEncode(notificacionModel),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelNotificationDateTime(NotificacionModel notificacionModel) async {
    await flutterLocalNotificationsPlugin.cancel(notificacionModel.hashCode);
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void handleApplicationWasLaunchedFromNotification() async {
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails.didNotificationLaunchApp) {
      NotificacionModel notificacionModel =
          getNotificacionModelFromPayload(notificationAppLaunchDetails.payload);
      cancelNotificationDateTime(notificacionModel);
      scheduleNotificationForDatetime(
          notificacionModel, "${notificacionModel.texto}!");
    }
  }

  NotificacionModel getNotificacionModelFromPayload(String payload) {
    Map<String, dynamic> json = jsonDecode(payload);
    NotificacionModel notificacionModel = NotificacionModel.fromJson(json);
    return notificacionModel;
  }

  Future<bool> _wasApplicationLaunchedFromNotification() async {
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    return notificationAppLaunchDetails.didNotificationLaunchApp;
  }
}
