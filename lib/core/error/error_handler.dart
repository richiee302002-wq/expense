import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void logError(Object error, StackTrace stack) {
    // In a real app, send to Sentry/Firebase Crashlytics
    debugPrint('Global Error Caught: $error');
    debugPrint('Stack Trace: $stack');
  }
}
