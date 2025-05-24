import 'package:flutter/material.dart';

void showMessage(BuildContext context, String title, String content,
    [List<Widget>? actions]) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
      );
    },
  );
}
