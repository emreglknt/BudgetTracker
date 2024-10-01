import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/expenseModel.dart';

abstract class authApiDataSource {
  Future<void> addExpense(double expense, String category, String date);
  Stream<List<Expense>> getAllExpenses();
}

class BudgetApi implements authApiDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add expense
  @override
  Future<void> addExpense(double expense, String category, String date) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("Kullanıcı oturumu açık değil.");
      }

      String userId = currentUser.uid;
      await _firestore.collection('users').doc(userId).collection('expenses')
          .add({
        'price': expense,
        'category': category,
        'date': date,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("Harcama başarıyla eklendi.");
    } catch (e) {
      throw Exception("Error Occured: $e");
    }
  }

  // Get all expenses
  @override
  Stream<List<Expense>> getAllExpenses() {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception("Kullanıcı oturumu açık değil.");
    }
    try {
      String userId = currentUser.uid;

      return _firestore.collection('users')
          .doc(userId)
          .collection('expenses')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => Expense.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

    } on Exception catch (e) {
      throw Exception("Error Occured: $e");
    }
  }

}
