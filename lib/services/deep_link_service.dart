import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/providers.dart';
import '../presentation/screens/transaction_detail_screen.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  final WidgetRef ref;
  final BuildContext context;

  DeepLinkService(this.ref, this.context);

  void init() {
    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) async {
    // Expected format: app://tx/{id}
    if (uri.host == 'tx' && uri.pathSegments.isNotEmpty) {
      final transactionId = uri.pathSegments.first;
      _navigateToTransaction(transactionId);
    }
  }

  Future<void> _navigateToTransaction(String id) async {
    try {
      // Fetch transaction from repository
      // Note: This requires a method to get transaction by ID which might not exist in Repo yet
      // Or we can rely on the list if loaded. For now, let's assume valid ID.
      // Actually, we need to fetch it.

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
