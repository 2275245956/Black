import 'package:tripledes/tripledes.dart';

class EncryptAes{
  String doEncrypt(String pass){
    var key = "yeejoin1";
    var blockCipher = new BlockCipher(new DESEngine(), key);
    var plainText = pass;
    var encryptText = blockCipher.encodeB64(plainText);
    var decodedText = blockCipher.decodeB64(encryptText);

    print("key: $key");
    print("message: $plainText");
    print("ciphertext (base64): $encryptText");
    print("decoded ciphertext: $decodedText");

    return encryptText;
  }

}