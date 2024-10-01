import 'dart:ffi';

import 'package:budget_family/data/model/expenseModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../api/data_source.dart';



// Repo function implementation class
abstract class IMainRepository{
  Future <Either<String,String>> addExpense(double expense, String category, String date);
  Stream<Either<String, Tuple2<List<Expense>, double>>>  getAllExpense();
}



class MainRepository extends IMainRepository{

  final budgetApi = BudgetApi();




  //add expense
  @override
  Future<Either<String, String>> addExpense(double expense, String category, String date) async {
    try {
      final result = await budgetApi.addExpense(expense, category, date);
      return right("success");
    } on DioError catch (e) {
      return left(e.toString());
    }
  }






  @override
  Stream<Either<String, Tuple2<List<Expense>, double>>> getAllExpense() async* {
    try {
      yield* budgetApi.getAllExpenses().map((expenseList) {
        double totalExpense = expenseList.fold(
          0.0,
              (sum, item) => sum + item.price,
        );
        return right(Tuple2(expenseList, totalExpense));
      });
    } on FirebaseException catch (e) {
      yield left(e.message ?? 'Firebase hatası oluştu.');
    } catch (e) {
      yield left('Harcama bilgilerini alırken hata oluştu.');
    }
  }




}