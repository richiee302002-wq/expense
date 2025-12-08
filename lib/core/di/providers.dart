import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/transactions_dao.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../api_client.dart';
export '../../services/auth_service.dart';

// Database
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final transactionsDaoProvider = Provider<TransactionsDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TransactionsDao(db);
});

// API
final apiClientProvider = Provider<ApiClient>((ref) {
  // TODO: Move base URL to config/env
  return ApiClient(baseUrl: 'http://10.0.2.2:3000');
});

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RemoteDataSourceImpl(apiClient.dio);
});

// Repository
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final localDataSource = ref.watch(transactionsDaoProvider);
  final remoteDataSource = ref.watch(remoteDataSourceProvider);
  return TransactionRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});
