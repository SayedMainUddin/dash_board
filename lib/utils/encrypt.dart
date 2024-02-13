import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/export.dart';
import 'dart:convert';
import 'package:pointycastle/pointycastle.dart';

Uint8List hexStringToBytes(String hexString) {
  final buffer = List<int>.generate(hexString.length ~/ 2, (i) => int.parse(hexString.substring(i * 2, i * 2 + 2), radix: 16));
  return Uint8List.fromList(buffer);
}

// Usage

String decrypt(String encryptedData, String id, String customIV) {
  try {
    final keyBytes = Uint8List.fromList(utf8.encode(id));
    final ivBytes = base64.decode(customIV);

    final key = KeyParameter(keyBytes);
    final params = ParametersWithIV(key, ivBytes);

    final cipher = CBCBlockCipher(AESFastEngine());
    cipher.init(false, params);

    final encryptedBytes = base64.decode(encryptedData);
    final decryptedBytes = _processBlocks(cipher, encryptedBytes);

    return utf8.decode(decryptedBytes);
  } catch (error) {
    print('Decryption error: $error');
    // Handle the error or rethrow if needed
    throw Exception('Decryption failed');
  }
}

Uint8List _processBlocks(BlockCipher cipher, Uint8List data) {
  final output = Uint8List(cipher.blockSize * ((data.length / cipher.blockSize).ceil()));
  var offset = 0;

  for (var i = 0; i < data.length; i += cipher.blockSize) {
    offset += cipher.processBlock(data, i, output, offset);
  }

  return output;
}

String generateEncryptionKey() {
  // Generate a random key (32 bytes) using crypto library
  final key = List<int>.generate(32, (index) => index);
  return base64.encode(key);
}

// String encrypt(String data, String key) {
//   final iv = IV.fromSecureRandom(16);
//   final encrypter = Encrypter(AES(Key.fromBase64(key)));
//
//   final encrypted = encrypter.encrypt(data, iv: iv);
//   return encrypted.base64;
// }
String encrypt(String data) {
  //String encryptionKey = generateEncryptionKey();
  final key = Key.fromSecureRandom(32);
  final iv = IV.fromSecureRandom(16);
  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(data, iv: iv);

  // Encode the encrypted data to base64 string
  String base64EncryptedData = encrypted.base64;

  return base64EncryptedData;
}