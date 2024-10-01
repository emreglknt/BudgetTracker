import 'package:firebase_auth/firebase_auth.dart';

String handleFirebaseAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'Geçersiz e-posta adresi.';
    case 'user-disabled':
      return 'Bu kullanıcı hesabı devre dışı bırakıldı.';
    case 'user-not-found':
      return 'Kullanıcı bulunamadı.';
    case 'wrong-password':
      return 'Yanlış şifre.';
    case 'email-already-in-use':
      return 'Bu e-posta adresi zaten kullanılıyor.';
    case 'weak-password':
      return 'Şifre çok zayıf.';
    default:
      return 'Bir hata oluştu: ${e.message}';
  }
}