import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../core/di/providers.dart';

class SyncService {
  final TransactionRepository _repository;

  SyncService(this._repository);

  Future<void> sync() async {
    try {
      await _repository.syncTransactions();
    } catch (e) {
      // Handle sync error (e.g., log it, retry later)
      // debugPrint('Sync failed: $e');
    }
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return SyncService(repository);
});
