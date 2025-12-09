import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_links/uni_links.dart';
import '../core/di/providers.dart';
import '../presentation/screens/transaction_detail_screen.dart';

class DeepLinkService {
  final WidgetRef ref;
  final BuildContext context;

  DeepLinkService(this.ref, this.context);

  void init() {
    // Check initial link
    getInitialUri().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });

    // Listen for incoming links
    uriLinkStream.listen((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    // Expected format: app://tx/{id}
    if (uri.host == 'tx' && uri.pathSegments.isNotEmpty) {
      final transactionId = uri.pathSegments.first;
      _navigateToTransaction(transactionId);
    }
  }

  Future<void> _navigateToTransaction(String id) async {
    try {
      final repo = ref.read(transactionRepositoryProvider);
      final transactions = await repo.getTransactions();

      final transaction = transactions.firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Transaction not found'),
      );

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TransactionDetailScreen(transaction: transaction),
          ),
        );
      }
    } catch (e) {
      debugPrint('Deep Link Error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Transaction not found: $id')));
      }
    }
  }
}
