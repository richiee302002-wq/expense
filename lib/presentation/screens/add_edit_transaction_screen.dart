import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../core/di/providers.dart';
import '../viewmodels/transaction_list_viewmodel.dart';

class AddEditTransactionScreen extends ConsumerStatefulWidget {
  final TransactionEntity? transaction;

  const AddEditTransactionScreen({super.key, this.transaction});

  @override
  ConsumerState<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState
    extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _categoryController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.transaction?.category ?? '',
    );
    _noteController = TextEditingController(
      text: widget.transaction?.note ?? '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final category = _categoryController.text;
      final note = _noteController.text;

      final transaction =
          widget.transaction?.copyWith(
            amount: amount,
            category: category,
            note: note,
            updatedAt: DateTime.now(),
            editedLocally: true,
          ) ??
          TransactionEntity(
            id: const Uuid().v4(),
            amount: amount,
            category: category,
            ts: DateTime.now(),
            note: note,
            editedLocally: true,
            updatedAt: DateTime.now(),
          );

      if (widget.transaction == null) {
        await ref
            .read(transactionRepositoryProvider)
            .addTransaction(transaction);
      } else {
        await ref
            .read(transactionRepositoryProvider)
            .updateTransaction(transaction);
      }

      // Refresh the list
      await ref.refresh(transactionListProvider.notifier).loadTransactions();

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction == null ? 'Add Transaction' : 'Edit Transaction',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
