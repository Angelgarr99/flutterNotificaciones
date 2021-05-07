import 'package:flutter/material.dart';

class AdmNotificacionesPage extends StatefulWidget {
  @override
  _AdmNotificacionesPageState createState() => _AdmNotificacionesPageState();
}

class _AdmNotificacionesPageState extends State<AdmNotificacionesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programar Notificación'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        children: [
          Text('data'),
          Divider(),
        ],
      ),
    );
  }
}
