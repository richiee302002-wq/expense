import 'package:drift/drift.dart';
import 'app_database.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  Future<List<Transaction>> getAllTransactions() => select(transactions).get();

  Future<List<Transaction>> getEditedLocally() =>
      (select(transactions)..where((t) => t.editedLocally.equals(true))).get();

  Future<Transaction?> findById(String id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertTransaction(TransactionsCompanion entry) =>
      into(transactions).insertOnConflictUpdate(entry);

  Future<void> deleteTransaction(String id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  Future<void> markAsSynced(String id) {
    return (update(transactions)..where((t) => t.id.equals(id))).write(
      const TransactionsCompanion(editedLocally: Value(false)),
    );
  }
}
