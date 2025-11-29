// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppConnectionStateImpl _$$AppConnectionStateImplFromJson(
  Map<String, dynamic> json,
) => _$AppConnectionStateImpl(
  status:
      $enumDecodeNullable(_$ConnectionStatusEnumMap, json['status']) ??
      ConnectionStatus.disconnected,
  connectedEndpointId: json['connectedEndpointId'] as String?,
  logText: json['logText'] as String? ?? 'Initializing...',
  isAdvertiser: json['isAdvertiser'] as bool? ?? false,
);

Map<String, dynamic> _$$AppConnectionStateImplToJson(
  _$AppConnectionStateImpl instance,
) => <String, dynamic>{
  'status': _$ConnectionStatusEnumMap[instance.status]!,
  'connectedEndpointId': instance.connectedEndpointId,
  'logText': instance.logText,
  'isAdvertiser': instance.isAdvertiser,
};

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.disconnected: 'disconnected',
  ConnectionStatus.advertising: 'advertising',
  ConnectionStatus.discovering: 'discovering',
  ConnectionStatus.connected: 'connected',
};
