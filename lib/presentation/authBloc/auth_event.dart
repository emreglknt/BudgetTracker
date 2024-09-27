part of 'auth_bloc.dart';

@immutable

sealed class AuthEvent {}

class AuthLoginRequest extends AuthEvent{
  final String email;
  final String password;
  AuthLoginRequest(this.email, this.password);
}




class AuthRegisterRequest extends AuthEvent{
  final String username;
  final String email;
  final String password;
  AuthRegisterRequest(this.username,this.email, this.password);
}


