import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../core/di/providers.dart';

final transactionListProvider =
    StateNotifierProvider<
      TransactionListViewModel,
      AsyncValue<List<TransactionEntity>>
    >((ref) {
      final repository = ref.watch(transactionRepositoryProvider);
      return TransactionListViewModel(repository);
    });

class TransactionListViewModel
    extends StateNotifier<AsyncValue<List<TransactionEntity>>> {
  final dynamic
  _repository; // Using dynamic to avoid import cycle if repository interface is in a different package, but here it's fine.
  // Actually, better to use the interface.

  TransactionListViewModel(this._repository)
    : super(const AsyncValue.loading()) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final transactions = await _repository.getTransactions();
      state = AsyncValue.data(transactions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _repository.deleteTransaction(id);
      // Refresh list
      await loadTransactions();
    } catch (e) {
      // Handle error
    }
  }
}
