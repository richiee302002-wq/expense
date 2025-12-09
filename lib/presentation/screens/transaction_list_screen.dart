import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/transaction_list_viewmodel.dart';
import 'add_edit_transaction_screen.dart';
import 'transaction_detail_screen.dart';
import 'statistics_screen.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';

import '../../services/deep_link_service.dart';

class TransactionListScreen extends ConsumerStatefulWidget {
  const TransactionListScreen({super.key});

  @override
  ConsumerState<TransactionListScreen> createState() =>
      _TransactionListScreenState();
}

class _TransactionListScreenState extends ConsumerState<TransactionListScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize Deep Link Service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkService(ref, context).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionListState = ref.watch(transactionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          transactionListState.when(
            data: (transactions) => AppLocalizations.of(
              context,
            )!.transactionCount(transactions.length),
            loading: () => AppLocalizations.of(context)!.transactionListTitle,
            error: (_, __) =>
                AppLocalizations.of(context)!.transactionListTitle,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart),
            tooltip: 'View Statistics',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: transactionListState.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions found'));
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                title: Text(transaction.category),
                subtitle: Text(transaction.note ?? ''),
                trailing: Text('\$${transaction.amount.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TransactionDetailScreen(transaction: transaction),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditTransactionScreen(),
            ),
          );
        },
        tooltip: AppLocalizations.of(context)!.addTransaction,
        child: const Icon(Icons.add),
      ),
    );
  }
}
