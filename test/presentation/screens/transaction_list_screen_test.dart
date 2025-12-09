import 'dart:async';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/core/di/providers.dart';
import 'package:expense_tracker/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/presentation/screens/transaction_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
  });

  testWidgets('TransactionListScreen shows loading indicator', (tester) async {
    // Arrange
    final completer = Completer<List<TransactionEntity>>();
    when(
      () => mockRepository.getTransactions(),
    ).thenAnswer((_) => completer.future);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TransactionListScreen(),
        ),
      ),
    );

    // Initial state is loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Complete the future to avoid hanging
    completer.complete([]);
  });

  testWidgets('TransactionListScreen shows transactions', (tester) async {
    final tTransaction = TransactionEntity(
      id: '1',
      amount: 100.0,
      category: 'Food',
      ts: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    when(
      () => mockRepository.getTransactions(),
    ).thenAnswer((_) async => [tTransaction]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TransactionListScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Food'), findsOneWidget);
    expect(find.text('\$100.00'), findsOneWidget);
  });

  testWidgets('TransactionListScreen shows empty message', (tester) async {
    when(() => mockRepository.getTransactions()).thenAnswer((_) async => []);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TransactionListScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No transactions found'), findsOneWidget);
  });
}
