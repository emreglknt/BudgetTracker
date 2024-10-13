import 'package:budget_family/utils/auth_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/FirebaseErrorMessages.dart';
import '../api/data_source.dart';



abstract class IAuthRepository{
  Future <Either<String,String>> register (String username, String email, String password);
  Future <Either<String,String>> login(String email, String password);
  Future<void>logout();
}



class AuthRepository extends IAuthRepository{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


//Login
  @override
  Future<Either<String, String>> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          String username = userDoc.get('username');
          await AuthManager.saveTokenanUsername(user.uid,username);
          return right(username);
        } else {
          return left("Kullanıcı bilgileri bulunamadı.");
        }
      } else {
        return left("Giriş başarısız, kullanıcı bulunamadı.");
      }
    } on FirebaseAuthException catch (e) {
      return left(handleFirebaseAuthException(e));
    } catch (e) {
      return left("Bilinmeyen bir hata oluştu: ${e.toString()}");
    }
  }






  @override
  Future<Either<String, String>> register(String username, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(username);
        await user.reload();
        user = _firebaseAuth.currentUser;

        await _firestore.collection('users').doc(user!.uid).set({
          'username': username,
          'email': email,
          'created_at': FieldValue.serverTimestamp(),
        });

        return right('Success');
      } else {
        return left("Kayıt başarısız, kullanıcı bulunamadı.");
      }
    } on FirebaseAuthException catch (e) {
      return left(handleFirebaseAuthException(e));
    } catch (e) {
      return left("Bilinmeyen bir hata oluştu: ${e.toString()}");
    }
  }





  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await AuthManager.logout();
    } catch (e) {
      throw Exception("Çıkış işlemi sırasında bir hata oluştu: $e");
    }
  }






}