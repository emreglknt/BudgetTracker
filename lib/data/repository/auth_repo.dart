import 'package:budget_family/utils/auth_manager.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../api/data_source.dart';



abstract class IAuthRepository{
  Future <Either<String,String>> register (String username, String email, String password);
  Future <Either<String,Map<String, String>>> login(String email, String password);
  Future logout();
}



class AuthRepository extends IAuthRepository{

  final authenticationApi = BudgetApi();

  Future<Either<String, Map<String, String>>> login(String email, String password) async {
    try {
      var response = await authenticationApi.login(email, password); // Assume response is already parsed to a map

      String? token = response['access_token'];
      String? username = response['username'];

      if (token != null && username != null) {
        // Return the token and username as a map
        return right({"access_token": token, "username": username});
      } else {
        return left("Token or username is missing.");
      }
        } catch (e) {
      return left(e.toString()); // Handle exceptions and return error messages
    }
  }




  @override
  Future<Either<String, String>> register (String username, String email, String password) async{
    try{
      await authenticationApi.register(username,email, password);
      return right('Success');
    }on Exception catch(e){
      return left(e.toString());
    }
  }


  @override
  Future logout() async{
      await AuthManager.logout();
  }





}