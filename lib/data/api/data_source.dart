
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/auth_manager.dart';
import '../../utils/utils.dart';
import '../model/expenseModel.dart';

abstract class authApiDataSource{
  Future<void> register(String username,String email, String password);
  Future<void> login(String email, String password);
  Future<void> addExpense(double expense, String category, String date);
  Future<List<Expense>> getAllExpenses();
  Future<double> getTotalExpenses();

}


class BudgetApi implements authApiDataSource {

  final Dio _dio = DioProvider.provideDio();

  @override
  Future<Map<String, String?>> login(String email, String password) async {
    try {
      final response = await _dio.post('login', data: {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        final token = response.data?['access_token'];
        final username = response.data?['username']; // Get the username from response

        if (token != null && username != null) {
          AuthManager.saveToken(token);  // Save token
          return {"access_token": token, "username": username};  // Return both token and username
        } else {
          throw "Token or username not found";  // Throw an error if any is missing
        }
      } else {
        throw "Unexpected error: ${response.statusCode}";
      }
    } on DioError catch (e) {
      if (e.response != null && e.response!.data != null) {
        // Check the type of the response data
        if (e.response!.data is Map<String, dynamic>) {
          throw e.response!.data['message'] ?? "An error occurred during login.";
        } else if (e.response!.data is String) {
          throw e.response!.data;
        } else {
          throw "An unknown error occurred: ${e.response!.data}";
        }
      } else {
        throw "Failed to connect to the server.";  // If the response is null
      }
    }
  }





//register
  @override
  Future<void> register (String username, String email, String password) async {
    try{
      final response = await _dio.post('register',data:{
        "username":username,
        "email": email,
        "password": password,
      });

    }on DioError catch(e){
      throw e.response!.data['message'];
    }
  }





// add expense
  @override
  Future<void> addExpense(double expense, String category, String date) async {
    final token = AuthManager.readAuth();
    try {
      final response = await _dio.post('expenses',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Attach the token
          },
        ),
        data: {
          'price': expense,
          'category': category,
          'date': date,
        },
      );

    } on DioError catch (e) {
      print('Error adding expense: ${e.response?.data}');
      throw Exception('Failed to add expense: ${e.response?.data}');
    }
  }




// get all expenses
  @override
  Future<List<Expense>> getAllExpenses() async {
    final token = AuthManager.readAuth();
    try {
      final response = await _dio.get('expenses',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Attach the token
          },
        ),
      );
      List<Expense> allExpenses =
      (response.data as List).map((expenseJson) => Expense.fromJson(expenseJson)).toList();

      return allExpenses;

    }on DioError catch (e) {
      print('Error adding expense: ${e.response?.data}');
      throw Exception('Failed to add expense: ${e.response?.data}');
    }

  }



  //get total expenses
  @override
  Future<double> getTotalExpenses() async {
    final token = AuthManager.readAuth();
    try{
      final totalExpense = await _dio.get('expenses/total',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Attach the token
          },
        ),
      );
      return totalExpense.data['total_expenses'];
    }on DioError catch(e){
      throw Exception('Failed to add expense:');
    }

  }





}



