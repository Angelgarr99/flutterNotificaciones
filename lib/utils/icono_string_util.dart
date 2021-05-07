import 'package:flutter/material.dart';

final _icons = <String, IconData>{
  'add_alert': Icons.add_alert,
  'construction_outlined': Icons.construction_outlined
};

Icon getIcon(String nombreIcono) {
  return Icon(
    _icons[nombreIcono],
    color: Colors.blue,
  );
}
