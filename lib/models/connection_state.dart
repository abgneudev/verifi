import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_state.freezed.dart';
part 'connection_state.g.dart';

enum ConnectionStatus { disconnected, advertising, discovering, connected }

@freezed
class AppConnectionState with _$AppConnectionState {
  const factory AppConnectionState({
    @Default(ConnectionStatus.disconnected) ConnectionStatus status,
    String? connectedEndpointId,
    @Default('Initializing...') String logText,
    @Default(false)
    bool isAdvertiser, // Track if this device is the advertiser (seller)
  }) = _AppConnectionState;

  factory AppConnectionState.fromJson(Map<String, dynamic> json) =>
      _$AppConnectionStateFromJson(json);
}

const AppConnectionState initialConnectionState = AppConnectionState();
