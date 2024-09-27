import 'dart:ffi';

import 'package:budget_family/data/model/expenseModel.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../api/data_source.dart';



// Repo function implementation class
abstract class IMainRepository{
  Future <Either<String,String>> addExpense(double expense, String category, String date);
  Future<Either<String, List<Expense>>> getAllExpense();
  Future<Either<String,double>> getTotalExpenses();
}



class MainRepository extends IMainRepository{

  final budgetApi = BudgetApi();




  //add expense
  @override
  Future<Either<String, String>> addExpense(double expense, String category, String date) async {
    try {
      await budgetApi.addExpense(expense, category, date);
      return right('Success');
    } on DioError catch (e) {
      return left(e.response?.data['message'] ?? 'An error occurred');
    }
  }




  // get all expenses
  @override
  Future<Either<String, List<Expense>>> getAllExpense() async {
    try {
      final response = await budgetApi.getAllExpenses();
      return right(response);
    } on DioError catch (e) {
      return left(e.response?.data['message'] ?? 'Failed to fetch expenses');
    }
  }


  @override
  Future<Either<String,double>>getTotalExpenses() async{
    try{
      final total = await budgetApi.getTotalExpenses();
      return right(total);
    }on DioError catch(e){
      return left(e.response?.data['message'] ?? 'Failed to fetch expenses');
    }
  }






}