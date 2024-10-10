import 'dart:ffi';

import 'package:budget_family/data/model/expenseModel.dart';
import 'package:budget_family/data/model/pieChartModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../api/data_source.dart';



// Repo function implementation class
abstract class IMainRepository{
  Future <Either<String,String>> addExpense(double expense, String category, DateTime date);
  Stream<Either<String, Tuple3<List<Expense>, double, double>>> getAllExpensesAndIncome();
  Future <Either<String,double>> addIncome(double expense);
  Stream<Either<String,List<Expense>>> getAllExpenses();
  Stream<Either<String,List<Expense>>> getExpensesByCategory(List<String> categoryList);
  Stream<Either<String, Map<String, double>>> getPieChartList();
  Stream<Either<String,Map<String, double>>>getMonthlyExpenseData();
  Future <Either<String,double>> getCurrency(String target);
}



class MainRepository extends IMainRepository{

  final budgetApi = BudgetApi();




  //add expense
  @override
  Future<Either<String, String>> addExpense(double expense, String category, DateTime date) async {
    try {
      final result = await budgetApi.addExpense(expense, category, date);
      return right("success");
    } on DioError catch (e) {
      return left(e.toString());
    }
  }


  //get last 10expense total income total expense
  @override Stream<Either<String, Tuple3<List<Expense>, double, double>>> getAllExpensesAndIncome() async* {
    try {
      yield* budgetApi.getAllExpensesAndIncome().map((data) {
        List<Expense> expenseList = data['expenses'] as List<Expense>;  //expense list

        double totalExpense = expenseList.fold(   //total expense
          0.0,
              (sum, item) => sum + item.price,
        );
        double totalIncome = data['totalIncome'] as double;
        return right(Tuple3(expenseList, totalExpense, totalIncome));
      });
    } on FirebaseException catch (e) {
      yield left(e.message ?? 'Firebase hatası oluştu.');
    } catch (e) {
      yield left('Harcama bilgilerini alırken hata oluştu.');
    }
  }








  //get all expense
  @override
  Stream<Either<String,List<Expense>>> getAllExpenses()async* {
    try {
      yield* budgetApi.getAllExpenses().map((expenseList) {
        return right(expenseList);
      });
    } on FirebaseException catch (e) {
      yield left(e.message ?? 'Firebase hatası oluştu.');
    } catch (e) {
      yield left('Harcama bilgilerini alırken hata oluştu.');
    }
  }





  // get expense list by category filter
  @override
  Stream<Either<String,List<Expense>>> getExpensesByCategory(List<String> categoryList) async* {
    try {
      yield* budgetApi.getExpensesByCategory(categoryList).map((expenseList) {
        return right(expenseList);
      });
    } on FirebaseException catch (e) {
      yield left(e.message ?? 'Firebase hatası oluştu.');
    } catch (e) {
      yield left('Harcama bilgilerini alırken hata oluştu.');
    }
  }









  //add and return income
  @override
  Future<Either<String, double>> addIncome(double income) async{
   try{
     final totalIncome = await budgetApi.addIncome(income);
     return right(totalIncome);
   }on FirebaseException catch (e) {
     return left(e.message ?? 'Firebase hatası oluştu.');
   } catch (e) {
     return left('Cüzdan bilgilerini alırken hata oluştu.');
   }
  }





  // categories and their total expenses for PieChart

  @override
  Stream<Either<String, Map<String, double>>> getPieChartList() async* {
    try {
      yield* budgetApi.getPieChartList().map((categoryTotalMap) {
        if(categoryTotalMap.isEmpty){
          return left("MAP is emptyy");
        }
        return right(categoryTotalMap);
      });
    } on FirebaseException catch (e) {
      yield left(e.message ?? 'Firebase hatası oluştu.');
    } catch (e) {
      yield left('Harcama bilgilerini alırken hata oluştu.');
      
    }
  }





// get monthly expense
  @override
  Stream<Either<String, Map<String, double>>> getMonthlyExpenseData() async* {
    try {
      final allExpensesStream = budgetApi.getAllExpenses(); // Call the function to get all expenses
      await for (final expenseList in allExpensesStream) {
        Map<String, double> monthlyExpenses = {};

        for (var expense in expenseList) {

          DateTime expenseDate = expense.date;
          String month = "${expenseDate.year}-${expenseDate.month.toString().padLeft(2, '0')}";

          if (monthlyExpenses.containsKey(month)) {
            monthlyExpenses[month] = monthlyExpenses[month]! + expense.price;
          } else {
            monthlyExpenses[month] = expense.price;
          }
        }

        yield Right(monthlyExpenses);
      }
    } catch (e) {
      yield Left("An error occurred: $e");
    }
  }








  @override
  Future <Either<String,double>> getCurrency(String target) async{
    try{
      final currency = await budgetApi.getCurrency(target);
      print("currency main repo :$currency");
      return right(currency);
    }on FirebaseException catch (e) {
      return left(e.message!);
    } catch (e) {
      return left('Currency Error');
    }
  }







}