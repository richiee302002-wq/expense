import 'package:expense_tracker/core/di/providers.dart';
import 'package:expense_tracker/domain/repositories/transaction_repository.dart';
import 'package:expense_tracker/presentation/screens/add_edit_transaction_screen.dart';
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

  testWidgets('AddEditTransactionScreen shows validation errors', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(home: AddEditTransactionScreen()),
      ),
    );

    // Tap save without entering data
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Please enter an amount'), findsOneWidget);
    expect(find.text('Please enter a category'), findsOneWidget);
  });

  testWidgets('AddEditTransactionScreen enters data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transactionRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(home: AddEditTransactionScreen()),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '50');
    await tester.enterText(find.byType(TextFormField).at(1), 'Transport');

    expect(find.text('50'), findsOneWidget);
    expect(find.text('Transport'), findsOneWidget);
  });
}
