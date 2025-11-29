import 'package:freezed_annotation/freezed_annotation.dart';

part 'escrow_state.freezed.dart';
part 'escrow_state.g.dart';

enum EscrowStatus { idle, locked, unlocked }

@freezed
class EscrowState with _$EscrowState {
  const factory EscrowState({
    @Default(0.0) double amount,
    @Default(EscrowStatus.idle) EscrowStatus status,
  }) = _EscrowState;

  factory EscrowState.fromJson(Map<String, dynamic> json) =>
      _$EscrowStateFromJson(json);
}

const EscrowState initialEscrowState = EscrowState();
