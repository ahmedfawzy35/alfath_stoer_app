import 'package:flutter/material.dart';

class MyDialogs {
  static void _showOkCancleDialog(BuildContext context,
      {required String title, required String quistion}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
                fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
              width: double.minPositive,
              child: Text(quistion,
                  style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold))),
          actions: [
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Ok')),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Cancel'))
          ],
        );
      },
    );
  }
}
