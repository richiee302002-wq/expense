import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../viewmodels/transaction_list_viewmodel.dart';
import 'add_edit_transaction_screen.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final TransactionEntity transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat.yMMMd().add_jm();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transactionDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditTransactionScreen(transaction: transaction),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.delete),
                  content: Text(
                    AppLocalizations.of(context)!.deleteConfirmation,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(AppLocalizations.of(context)!.delete),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await ref
                    .read(transactionListProvider.notifier)
                    .deleteTransaction(transaction.id);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.amount,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${transaction.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: transaction.amount < 0
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              AppLocalizations.of(context)!.category,
              transaction.category,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              'Date',
              dateFormat.format(transaction.ts),
            ), // 'Date' key missed in arb
            if (transaction.note != null && transaction.note!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildDetailRow(
                context,
                AppLocalizations.of(context)!.note,
                transaction.note!,
              ),
            ],
            if (transaction.attachmentPath != null) ...[
              const SizedBox(height: 16),
              _buildDetailRow(
                context,
                'Attachment',
                transaction.attachmentPath!.split('/').last,
              ),
            ],
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              'Status', // 'Status' key missed in arb
              transaction.editedLocally ? 'Unsynced' : 'Synced', // Keys missed
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
        const Divider(),
      ],
    );
  }
}
