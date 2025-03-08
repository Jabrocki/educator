//Material
import 'package:flutter/material.dart';

void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Row(
          children: [
            // Common warning icon – feel free to make this optional or dynamic
            const Icon(Icons.warning_amber_rounded, size: 28),
            const SizedBox(width: 8.0),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

