import 'package:expense_tracker/data/datasources/local/app_database.dart';
import 'package:expense_tracker/data/datasources/local/transactions_dao.dart';
import 'package:expense_tracker/data/datasources/remote/remote_datasource.dart';
import 'package:expense_tracker/data/repositories/transaction_repository_impl.dart';
import 'package:expense_tracker/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionsDao extends Mock implements TransactionsDao {}

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  late TransactionRepositoryImpl repository;
  late MockTransactionsDao mockDao;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockDao = MockTransactionsDao();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = TransactionRepositoryImpl(
      localDataSource: mockDao,
      remoteDataSource: mockRemoteDataSource,
    );

    registerFallbackValue(
      TransactionEntity(
        id: 'fallback',
        amount: 0,
        category: 'fallback',
        ts: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    // Register fallback for TransactionCompanion if needed, but we can usually mock around it
    // or use a fake. For now, let's see if we can get by without it or mock the DAO methods loosely.
  });

  final tTransaction = TransactionEntity(
    id: '1',
    amount: 50.0,
    category: 'Transport',
    ts: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final tTransactionData = Transaction(
    id: '1',
    amount: 50.0,
    category: 'Transport',
    ts: DateTime.now().millisecondsSinceEpoch,
    updatedAt: DateTime.now().millisecondsSinceEpoch,
    editedLocally: false,
  );

  test('getTransactions should return list from DAO', () async {
    // Arrange
    when(
      () => mockDao.getAllTransactions(),
    ).thenAnswer((_) async => [tTransactionData]);

    // Act
    final result = await repository.getTransactions();

    // Assert
    expect(result.length, 1);
    expect(result.first.id, tTransaction.id);
    verify(() => mockDao.getAllTransactions()).called(1);
  });

  test('syncTransactions should push local changes and fetch remote', () async {
    // Arrange
    when(
      () => mockDao.getEditedLocally(),
    ).thenAnswer((_) async => [tTransactionData]);
    when(
      () => mockRemoteDataSource.pushBatch(any()),
    ).thenAnswer((_) async => [tTransaction]);
    when(() => mockDao.markAsSynced(any())).thenAnswer((_) async {});
    when(
      () => mockRemoteDataSource.fetchTransactions(),
    ).thenAnswer((_) async => []);

    // Act
    await repository.syncTransactions();

    // Assert
    verify(() => mockDao.getEditedLocally()).called(1);
    verify(() => mockRemoteDataSource.pushBatch(any())).called(1);
    verify(() => mockDao.markAsSynced('1')).called(1);
    verify(() => mockRemoteDataSource.fetchTransactions()).called(1);
  });
}
