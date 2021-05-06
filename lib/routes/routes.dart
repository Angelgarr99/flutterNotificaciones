import 'package:flutter/material.dart';
import 'package:programar_notifi/pages/crear_notifi.dart';
import 'package:programar_notifi/pages/home_page.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'notificacion': (BuildContext context) => CrearNotifiPage(),
  };
}
