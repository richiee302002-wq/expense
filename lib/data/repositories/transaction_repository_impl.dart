import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/local/transactions_dao.dart';
import '../datasources/remote/remote_datasource.dart';
import '../models/transaction_mapper.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionsDao localDataSource;
  final RemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    // For now, return local data. Sync logic will be added later.
    final localTransactions = await localDataSource.getAllTransactions();
    return localTransactions.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    await localDataSource.upsertTransaction(transaction.toCompanion());
    // Trigger sync or push to remote in background
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    await localDataSource.upsertTransaction(transaction.toCompanion());
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await localDataSource.deleteTransaction(id);
  }

  @override
  Future<void> syncTransactions() async {
    // 1. Push local changes to remote
    final localChanges = await localDataSource.getEditedLocally();
    if (localChanges.isNotEmpty) {
      try {
        final pushedTransactions = await remoteDataSource.pushBatch(
          localChanges.map((e) => e.toEntity()).toList(),
        );

        // Mark as synced locally
        for (final transaction in pushedTransactions) {
          await localDataSource.markAsSynced(transaction.id);
        }
      } catch (e) {
        // Failed to push, will retry next time
        // debugPrint('Failed to push changes: $e');
      }
    }

    // 2. Fetch remote changes
    try {
      // Get last updated timestamp from local DB (simplified for now)
      // In a real app, we'd store the last sync timestamp in shared preferences or DB
      final remoteTransactions = await remoteDataSource.fetchTransactions();

      for (final transaction in remoteTransactions) {
        await localDataSource.upsertTransaction(transaction.toCompanion());
      }
    } catch (e) {
      // debugPrint('Failed to fetch changes: $e');
    }
  }
}
