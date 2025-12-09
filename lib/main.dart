import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/login_screen.dart';
import 'services/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';

import 'package:workmanager/workmanager.dart';
import 'core/error/error_handler.dart';
import 'dart:async';

@pragma(
  'vm:entry-point',
) // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    await NotificationService().showDailyReminder();

    return Future.value(true);
  });
}

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await NotificationService().init();
      // Initialize Workmanager
      await Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
      );
      await NotificationService().scheduleDailyNotification();

      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stack) {
      ErrorHandler.logError(error, stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ta'), // Tamil
      ],
      home: const LoginScreen(),
    );
  }
}
