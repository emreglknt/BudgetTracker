import 'package:budget_family/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../model/ExchangeRateModel.dart';
import '../model/expenseModel.dart';
import '../model/pieChartModel.dart';

abstract class authApiDataSource {
  Future<void> addExpense(double expense, String category, DateTime date);
  Stream<List<Expense>> getAllExpenses();
  Stream<Map<String, dynamic>> getAllExpensesAndIncome();
  Future<double> addIncome(double income);
  Stream<List<Expense>> getExpensesByCategory(List<String> categoryList);
  Stream<Map<String, double>> getPieChartList();
  Future<double> getCurrency(String target);
  Stream<Map<String, double>> getMonthlyExpenses();

}

class BudgetApi implements authApiDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio dio = Dio();


  // Add expense
  @override
  Future<void> addExpense(double expense, String category, DateTime date) async {
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



// Get all expenses and total income
  @override
  Stream<Map<String, dynamic>> getAllExpensesAndIncome() {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("Kullanıcı oturumu açık değil.");
    }
    try {
      String userId = currentUser.uid;
      // Expenses
      Stream<List<Expense>> expensesStream = _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .orderBy('createdAt', descending: true)
          .limit(10)  // return last 10 expenses to the list
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => Expense.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

      // Total Income
      Stream<double> totalIncomeStream = _firestore
          .collection('users')
          .doc(userId)
          .collection('income')
          .doc('incomeData')
          .snapshots()
          .map((docSnapshot) {
        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>?;
          return data?['totalIncome'] ?? 0.0;
        } else {
          return 0.0;
        }
      });
      return Rx.combineLatest2(
        expensesStream,
        totalIncomeStream,
            (List<Expense> expenses, double totalIncome) {
          return {
            'expenses': expenses,
            'totalIncome': totalIncome,
          };
        },
      );
    } on Exception catch (e) {
      throw Exception("Error Occured: $e");
    }
  }





  //get all expenses
  @override
  Stream<List<Expense>> getAllExpenses() {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("Kullanıcı oturumu açık değil.");
    }
    try {
      String userId = currentUser.uid;
      Stream<List<Expense>> allExpenses = _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => Expense.fromJson(doc.data() as Map<String, dynamic>))
          .toList());
      return allExpenses;
    } on Exception catch (e) {
      throw Exception("Error Occured: $e");
    }
  }




//get all expenses by categoryList
  @override
  Stream<List<Expense>> getExpensesByCategory(List<String> categoryList) {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("Kullanıcı oturumu açık değil.");
    }
    try {
      String userId = currentUser.uid;
      Stream<List<Expense>> allCategoryExpenses = _firestore
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .where('category', whereIn: categoryList)
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => Expense.fromJson(doc.data() as Map<String, dynamic>))
          .toList());
      return  allCategoryExpenses;
    } on Exception catch (e) {
      throw Exception("Error Occured: $e");
    }
  }







  // Add income and return the updated total income
  @override
  Future<double> addIncome(double income) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("Kullanıcı oturumu açık değil.");
      }
      String userId = currentUser.uid;
      DocumentReference incomeDocRef = _firestore.collection('users').doc(userId).collection('income').doc('incomeData');
      DocumentSnapshot incomeSnapshot = await incomeDocRef.get();
      double updatedIncome;

      if (incomeSnapshot.exists) {
        double currentIncome = incomeSnapshot.get('totalIncome') ?? 0;
        updatedIncome = currentIncome + income;
        await incomeDocRef.update({
          'totalIncome': updatedIncome,
        });
      } else {
        updatedIncome = income;
        await incomeDocRef.set({
          'totalIncome': updatedIncome,
        });
      }
      return updatedIncome;
    } catch (e) {
      throw Exception("Error Occurred: $e");
    }
  }




  //get currency
  @override
  Future<double> getCurrency(String base) async {
    try {
      print("Fetching currency exchange rate for target: $base");

      Response currencyResponse =await dio.get("https://hexarate.paikama.co/api/rates/latest/$base", queryParameters: {
        'target': "TRY",
      });

      ExchangeRateResponse exchangeRateResponse = ExchangeRateResponse.fromJson(currencyResponse.data);

      return exchangeRateResponse.data.mid;
    } catch (e) {
      print("Error fetching currency: $e");
      throw Exception("Currency conversion failed");
    }
  }






  // Kategorileri ve toplamlarını döndür
  @override
  Stream<Map<String, double>> getPieChartList() {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("Kullanıcı oturumu açık değil.");
      }
      String userId = currentUser.uid;


      return _firestore.collection("users")
          .doc(userId)
          .collection("expenses")
          .snapshots()
          .map((snapshot) {

        Map<String, double> categoryTotalMap = {};

        for (var doc in snapshot.docs) {
          Expense expense = Expense.fromJson(doc.data() as Map<String, dynamic>);
          String category = expense.category;
          double price = expense.price;


          if (categoryTotalMap.containsKey(category)) {
            categoryTotalMap[category] = categoryTotalMap[category]! + price;
          } else {
            categoryTotalMap[category] = price;
          }
        }


        return categoryTotalMap;
      });
    } on Exception catch (e) {
      throw Exception("Error Occurred: $e");
    }
  }





//Get Monthly Expenses
  @override
  Stream<Map<String, double>> getMonthlyExpenses() {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("Kullanıcı oturumu açık değil.");
      }
      String userId = currentUser.uid;

      return _firestore
          .collection("users")
          .doc(userId)
          .collection("expenses")
          .orderBy('date', descending: false)
          .snapshots()
          .map((snapshot) {
        Map<String, double> monthlyExpensesMap = {};

        for (var doc in snapshot.docs) {
          Expense expense = Expense.fromJson(doc.data() as Map<String, dynamic>);
          DateTime expenseDate = expense.date;

          String monthKey = "${expenseDate.year}-${expenseDate.month.toString().padLeft(2, '0')}";

          double price = expense.price;

          if (monthlyExpensesMap.containsKey(monthKey)) {
            monthlyExpensesMap[monthKey] = monthlyExpensesMap[monthKey]! + price;
          } else {
            monthlyExpensesMap[monthKey] = price;
          }
        }

        return monthlyExpensesMap;
      });
    } on Exception catch (e) {
      throw Exception("Error Occurred: $e");
    }
  }






















}







