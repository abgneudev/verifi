import 'package:cryptography/cryptography.dart';

class CryptoService {
  final algorithm = Ed25519();
  SimpleKeyPair? _keyPair;

  SimpleKeyPair? get keyPair => _keyPair;

  Future<void> generateKeys() async {
    _keyPair = await algorithm.newKeyPair();
  }

  Future<Signature> sign(List<int> data) async {
    if (_keyPair == null) {
      throw Exception('Keys not generated yet');
    }
    return await algorithm.sign(data, keyPair: _keyPair!);
  }

  Future<bool> verify(List<int> data, Signature signature) async {
    return await algorithm.verify(data, signature: signature);
  }

  Future<SimplePublicKey> getPublicKey() async {
    if (_keyPair == null) {
      throw Exception('Keys not generated yet');
    }
    return await _keyPair!.extractPublicKey();
  }
}
