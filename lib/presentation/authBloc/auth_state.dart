part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState{}

class RegisterLoadingState extends AuthState{}


class CreateFamilyLoadingState extends AuthState{}




class AuthSuccessState extends AuthState {
  final String? username;
  final String? errorMessage;
  AuthSuccessState({this.username ,this.errorMessage});
}



class RegisterSuccessState extends AuthState{
  final String message;
  RegisterSuccessState(this.message);
}



class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState(this.error);
}





