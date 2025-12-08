import 'package:dio/dio.dart';
import '../../../domain/entities/transaction_entity.dart';

abstract class RemoteDataSource {
  Future<List<TransactionEntity>> fetchTransactions({String? since});
  Future<List<TransactionEntity>> pushBatch(
    List<TransactionEntity> transactions,
  );
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl(this.dio);

  @override
  Future<List<TransactionEntity>> fetchTransactions({String? since}) async {
    final query = <String, dynamic>{'_sort': 'updatedAt', '_order': 'desc'};
    if (since != null) {
      query['updatedAt_gte'] = since;
    }

    final response = await dio.get('/transactions', queryParameters: query);
    return (response.data as List)
        .map((e) => TransactionEntity.fromJson(e))
        .toList();
  }

  @override
  Future<List<TransactionEntity>> pushBatch(
    List<TransactionEntity> transactions,
  ) async {
    final response = await dio.post(
      '/transactions/batch',
      data: transactions.map((e) => e.toJson()).toList(),
    );
    return (response.data as List)
        .map((e) => TransactionEntity.fromJson(e))
        .toList();
  }
}
