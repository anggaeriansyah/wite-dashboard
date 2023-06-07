import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      User? user = userCredential.user;
      // Lakukan tindakan setelah pengguna berhasil masuk secara anonim
    } catch (e) {
      print('Terjadi kesalahan: $e');
      // Tangani kesalahan saat masuk secara anonim
    }
  }

  static Future<void> signOut() async {
    _auth.signOut();
  }
}
