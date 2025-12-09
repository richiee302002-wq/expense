// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'செலவு மேலாளர்';

  @override
  String get transactionListTitle => 'பரிவர்த்தனைகள்';

  @override
  String get addTransaction => 'பரிவர்த்தனையைச் சேர்';

  @override
  String get editTransaction => 'பரிவர்த்தனையைத் திருத்து';

  @override
  String get amount => 'தொகை';

  @override
  String get category => 'வகை';

  @override
  String get note => 'குறிப்பு';

  @override
  String get save => 'சேமி';

  @override
  String get transactionDetails => 'பரிவர்த்தனை விவரங்கள்';

  @override
  String get delete => 'நீக்கு';

  @override
  String get deleteConfirmation =>
      'இந்த பரிவர்த்தனையை நிச்சயமாக நீக்க விரும்புகிறீர்களா?';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get syncing => 'ஒத்திசைக்கிறது...';

  @override
  String get loginEnterPin => 'உங்கள் பின்னை உள்ளிடவும்';

  @override
  String get loginSetPin => '4 இலக்க பின்னை அமைக்கவும்';

  @override
  String get loginConfirmPin => 'உங்கள் பின்னை உறுதிப்படுத்தவும்';

  @override
  String get loginPinMismatch =>
      'பின்கள் பொருந்தவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get loginIncorrectPin => 'தவறான பின். மீண்டும் முயற்சிக்கவும்.';

  @override
  String get statistics => 'புள்ளிவிவரங்கள்';

  @override
  String get totalExpenses => 'மொத்த செலவுகள்';

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
