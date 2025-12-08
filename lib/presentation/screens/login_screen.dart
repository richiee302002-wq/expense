import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import 'transaction_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _pinController = TextEditingController();
  bool _isSettingUp = false;
  String? _firstPin;
  String _message = 'Checking security...';

  @override
  void initState() {
    super.initState();
    _checkPinStatus();
  }

  Future<void> _checkPinStatus() async {
    final authService = ref.read(authServiceProvider);
    final hasPin = await authService.hasPin();
    setState(() {
      _isSettingUp = !hasPin;
      _message = _isSettingUp
          ? AppLocalizations.of(context)!.loginSetPin
          : AppLocalizations.of(context)!.loginEnterPin;
    });
  }

  void _onPinChanged(String value) async {
    if (value.length == 4) {
      if (_isSettingUp) {
        if (_firstPin == null) {
          setState(() {
            _firstPin = value;
            _message = AppLocalizations.of(context)!.loginConfirmPin;
            _pinController.clear();
          });
        } else {
          if (value == _firstPin) {
            await ref.read(authServiceProvider).setPin(value);
            if (mounted) {
              _navigateToHome();
            }
          } else {
            setState(() {
              _message = AppLocalizations.of(context)!.loginPinMismatch;
              _firstPin = null;
              _pinController.clear();
            });
          }
        }
      } else {
        final isValid = await ref.read(authServiceProvider).verifyPin(value);
        if (isValid) {
          if (mounted) {
            _navigateToHome();
          }
        } else {
          setState(() {
            _message = AppLocalizations.of(context)!.loginIncorrectPin;
            _pinController.clear();
          });
        }
      }
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const TransactionListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.blue),
              const SizedBox(height: 32),
              Text(
                _message,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8),
                onChanged: _onPinChanged,
                decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
