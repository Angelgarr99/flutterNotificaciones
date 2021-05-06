import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:programar_notifi/model/notificacion_model.dart';
import 'package:programar_notifi/providers/notification_provider.dart';

class CrearNotifiPage extends StatefulWidget {
  @override
  _CrearNotifiPageState createState() => _CrearNotifiPageState();
}

class _CrearNotifiPageState extends State<CrearNotifiPage> {
  String _fecha = '';
  String _hora = '';
  String _text = '';
  DateTime _dateTime;
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldTimeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Programar Notificación'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        children: [
          _crearFecha(context),
          Divider(),
          _crearHora(context),
          Divider(),
          _crearMensaje(),
          Divider(),
          _button(context)
        ],
      ),
    );
  }

  Widget _button(BuildContext context) {
    return ElevatedButton(
      child: Text('Agregar Notificación'),
      onPressed: () {
        if (_fecha.length > 0 && _hora.length > 0 && _text.length > 0) {
          _dateTime = DateTime.parse('${_fecha.substring(0, 10)} $_hora:00');
          if (_dateTime.isAfter(DateTime.now())) {
            _mostrarAlert(context);
          } else {
            _mostrarAlertaFail(context,
                'No puede programar una notificación anterior al momento actual.');
          }
        } else {
          _mostrarAlertaFail(context, 'Faltan campos necesarios');
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        shape: StadiumBorder(),
      ),
    );
  }

  Widget _crearMensaje() {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        hintText: 'Ingrese cualquier texto',
        labelText: 'Texto',
        icon: Icon(Icons.textsms),
      ),
      onChanged: (valor) {
        setState(() => _text = valor);
      },
    );
  }

  Widget _crearFecha(BuildContext context) {
    return TextField(
      enableInteractiveSelection: false,
      controller: _inputFieldDateController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        hintText: 'Fecha',
        labelText: 'Fecha',
        icon: Icon(Icons.calendar_today),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  Widget _crearHora(BuildContext context) {
    return TextField(
      enableInteractiveSelection: false,
      controller: _inputFieldTimeController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        hintText: 'Hora',
        labelText: 'Hora',
        icon: Icon(Icons.timer),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectTime(context);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now(),
        lastDate: new DateTime(2025),
        locale: Locale('es', 'ES'));
    if (picked != null) {
      setState(() {
        _fecha = picked.toString();
        _inputFieldDateController.text = _fecha.substring(0, 10);
      });
    }
  }

  _selectTime(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _hora =
            '${_convierteHora(picked.hour)}:${_convierteHora(picked.minute)}';
        print(_hora);
        _inputFieldTimeController.text = _hora;
      });
    }
  }

  String _convierteHora(int valor) {
    if (valor < 9) {
      return '0' + valor.toString();
    }
    return valor.toString();
  }

  void _mostrarAlert(BuildContext context) {
    String textoDia = 'el dia: ${_fecha.substring(0, 10)}';
    if ((DateTime.now().day == DateTime.parse(_fecha).day &&
        DateTime.now().month == DateTime.parse(_fecha).month &&
        DateTime.now().year == DateTime.parse(_fecha).year)) {
      textoDia = 'hoy';
    }
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Text('Agregar Notificación'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    'Agregar una Notificación para $textoDia a las $_hora horas?'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(primary: Colors.red),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              TextButton(
                  style: TextButton.styleFrom(primary: Colors.blue),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _handleUserInput();
                    _aceptado();
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  void _mostrarAlertaFail(BuildContext context, String texto) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Text('Error'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(texto),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(primary: Colors.blue),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  void _aceptado() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Text('Notificación Agregada'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Se ha agregado la notificación exitosamente'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  style: TextButton.styleFrom(primary: Colors.blue),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true);
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  void _handleUserInput() {
    NotificacionModel nuevaNotificacion =
        new NotificacionModel(_text, _dateTime, false);
    // _addBirthdayToList(nuevaNotificacion);
    NotificationService().scheduleNotificationForDatetime(
        nuevaNotificacion, "${nuevaNotificacion.texto}");
  }
}
