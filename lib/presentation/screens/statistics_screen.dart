import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/transaction_list_viewmodel.dart';
import '../../domain/entities/transaction_entity.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionListState = ref.watch(transactionListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: transactionListState.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions found'));
          }
          return _buildChart(context, transactions);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildChart(
    BuildContext context,
    List<TransactionEntity> transactions,
  ) {
    final categoryTotals = <String, double>{};
    for (var t in transactions) {
      if (t.amount < 0) {
        // Only consider expenses
        categoryTotals[t.category] =
            (categoryTotals[t.category] ?? 0) + t.amount.abs();
      }
    }

    if (categoryTotals.isEmpty) {
      return const Center(child: Text('No expenses to show'));
    }

    final totalExpense = categoryTotals.values.reduce((a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sections: categoryTotals.entries.map((entry) {
                  final percentage = (entry.value / totalExpense) * 100;
                  return PieChartSectionData(
                    color:
                        Colors.primaries[categoryTotals.keys.toList().indexOf(
                              entry.key,
                            ) %
                            Colors.primaries.length],
                    value: entry.value,
                    title: '${percentage.toStringAsFixed(1)}%',
                    radius: 100,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: categoryTotals.entries.map((entry) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Colors.primaries[categoryTotals.keys.toList().indexOf(
                              entry.key,
                            ) %
                            Colors.primaries.length],
                  ),
                  title: Text(entry.key),
                  trailing: Text('\$${entry.value.toStringAsFixed(2)}'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
