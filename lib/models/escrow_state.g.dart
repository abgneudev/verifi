// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escrow_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EscrowStateImpl _$$EscrowStateImplFromJson(Map<String, dynamic> json) =>
    _$EscrowStateImpl(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status:
          $enumDecodeNullable(_$EscrowStatusEnumMap, json['status']) ??
          EscrowStatus.idle,
    );

Map<String, dynamic> _$$EscrowStateImplToJson(_$EscrowStateImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'status': _$EscrowStatusEnumMap[instance.status]!,
    };

const _$EscrowStatusEnumMap = {
  EscrowStatus.idle: 'idle',
  EscrowStatus.locked: 'locked',
  EscrowStatus.unlocked: 'unlocked',
};
