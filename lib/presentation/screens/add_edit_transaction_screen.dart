import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../core/di/providers.dart';
import '../viewmodels/transaction_list_viewmodel.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';

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
  String? _attachmentPath;

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
    _attachmentPath = widget.transaction?.attachmentPath;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _attachmentPath = result.files.single.path;
      });
    }
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
            attachmentPath: _attachmentPath,
            updatedAt: DateTime.now(),
            editedLocally: true,
          ) ??
          TransactionEntity(
            id: const Uuid().v4(),
            amount: amount,
            category: category,
            ts: DateTime.now(),
            note: note,
            attachmentPath: _attachmentPath,
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
          widget.transaction == null
              ? AppLocalizations.of(context)!.addTransaction
              : AppLocalizations.of(context)!.editTransaction,
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.amount,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount'; // Keeping validation simple for now or need more keys
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.category,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.note,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _attachmentPath != null
                          ? 'File: ${_attachmentPath!.split('/').last}'
                          : 'No file attached',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Attach'),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: Text(AppLocalizations.of(context)!.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
