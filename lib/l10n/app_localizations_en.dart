// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Expense Tracker';

  @override
  String get transactionListTitle => 'Transactions';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get note => 'Note';

  @override
  String get save => 'Save';

  @override
  String get transactionDetails => 'Transaction Details';

  @override
  String get delete => 'Delete';

  @override
  String get deleteConfirmation =>
      'Are you sure you want to delete this transaction?';

  @override
  String get cancel => 'Cancel';

  @override
  String get syncing => 'Syncing...';

  @override
  String get loginEnterPin => 'Enter your PIN';

  @override
  String get loginSetPin => 'Set a 4-digit PIN';

  @override
  String get loginConfirmPin => 'Confirm your PIN';

  @override
  String get loginPinMismatch => 'PINs do not match. Try again.';

  @override
  String get loginIncorrectPin => 'Incorrect PIN. Try again.';

  @override
  String get statistics => 'Statistics';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String transactionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Transactions',
      one: '1 Transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }
}
