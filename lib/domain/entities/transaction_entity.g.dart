// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionEntityImpl _$$TransactionEntityImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionEntityImpl(
  id: json['id'] as String,
  amount: (json['amount'] as num).toDouble(),
  category: json['category'] as String,
  ts: DateTime.parse(json['ts'] as String),
  note: json['note'] as String?,
  attachmentPath: json['attachmentPath'] as String?,
  editedLocally: json['editedLocally'] as bool? ?? false,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$TransactionEntityImplToJson(
  _$TransactionEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'category': instance.category,
  'ts': instance.ts.toIso8601String(),
  'note': instance.note,
  'attachmentPath': instance.attachmentPath,
  'editedLocally': instance.editedLocally,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
