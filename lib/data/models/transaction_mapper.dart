import 'package:drift/drift.dart' as drift;
import '../../domain/entities/transaction_entity.dart';
import '../datasources/local/app_database.dart';

extension TransactionMapper on Transaction {
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      amount: amount,
      category: category,
      ts: DateTime.fromMillisecondsSinceEpoch(ts),
      note: note,
      attachmentPath: attachmentPath,
      editedLocally: editedLocally,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }
}

extension TransactionEntityMapper on TransactionEntity {
  TransactionsCompanion toCompanion() {
    return TransactionsCompanion.insert(
      id: id,
      amount: amount,
      category: category,
      ts: ts.millisecondsSinceEpoch,
      note: drift.Value(note),
      attachmentPath: drift.Value(attachmentPath),
      editedLocally: drift.Value(editedLocally),
      updatedAt: updatedAt.millisecondsSinceEpoch,
    );
  }
}
