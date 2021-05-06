import 'package:programar_notifi/constants.dart';

class NotificacionModel {
  final String texto;
  final DateTime dateTime;
  bool hasNotification;

  NotificacionModel(this.texto, this.dateTime, this.hasNotification);

  void updateNotificationStatus(bool status) {
    this.hasNotification = status;
  }

  bool equals(NotificacionModel otraNotifacion) {
    return (this.texto == otraNotifacion.texto &&
        this.dateTime == otraNotifacion.dateTime);
  }

  NotificacionModel.fromJson(Map<String, dynamic> json)
      : texto = json[notificacionModelTextoKey],
        dateTime = DateTime.tryParse(json[notificacionModelDateKey]),
        hasNotification = json[notificacionModelHasNotificationKey];

  Map<String, dynamic> toJson() => {
        notificacionModelTextoKey: texto,
        notificacionModelDateKey: dateTime.toIso8601String(),
        notificacionModelHasNotificationKey: hasNotification
      };
}
