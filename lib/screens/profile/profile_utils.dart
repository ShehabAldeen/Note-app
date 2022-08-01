import 'dart:io';

import 'package:flutter/material.dart';

class ProfileUtils {
  static File image;


  void logOutMessage(BuildContext context,
      {String title, String content, Function() onPressed}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              // The "Yes" button
              TextButton(onPressed: onPressed, child: const Text('OK')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'))
            ],
          );
        });
  }
}
