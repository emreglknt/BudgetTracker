import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../data/repository/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final _authRepo = AuthRepository();
  AuthBloc() : super(AuthInitial()) {


    //login
    on<AuthLoginRequest>((event, emit) async {
      emit(AuthLoadingState());
      final loginResult = await _authRepo.login(event.email, event.password);
      loginResult.fold(
        (error) =>emit(AuthErrorState(error)),
          (username) => emit(AuthSuccessState(username: username))
      );
    });





    //register
    on<AuthRegisterRequest>((event, emit) async {
      emit(RegisterLoadingState());
      var register = await _authRepo.register(event.username ,event.email, event.password);
      register.fold(
            (failure) {
          emit(AuthErrorState(failure)); // Emit error state in case of failure
        },
            (success) {
          emit(RegisterSuccessState(success)); // Emit success state upon successful registration
        },
      );
    });










  }
}
