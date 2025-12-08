import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void logError(Object error, StackTrace stack) {
    // In a real app, send to Sentry/Firebase Crashlytics
    debugPrint('Global Error Caught: $error');
    debugPrint('Stack Trace: $stack');
  }
}
