import 'package:flutter/material.dart';

class NotificationService {
  static BuildContext context;

  static void showSnackBar(String message) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
