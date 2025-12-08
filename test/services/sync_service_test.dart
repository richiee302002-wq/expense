import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/services/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late SyncService syncService;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    syncService = SyncService(mockRepository);
  });

  test('sync should call repository.syncTransactions', () async {
    // Arrange
    when(() => mockRepository.syncTransactions()).thenAnswer((_) async {});

    // Act
    await syncService.sync();

    // Assert
    verify(() => mockRepository.syncTransactions()).called(1);
  });
}
