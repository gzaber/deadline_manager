import 'package:flutter/widgets.dart';

class Destination {
  const Destination({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final String path;
}
