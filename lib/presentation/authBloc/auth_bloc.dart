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
    // Bloc login function
    on<AuthLoginRequest>((event, emit) async {
      emit(AuthLoadingState());

      var login = await _authRepo.login(event.email, event.password);

      if (login.isRight()) {
        var response = login.getOrElse(() => {});
        String token = response['access_token'] ?? "null";
        String username = response['username'] ?? "unknown";

        if (token != "null" && username != "unknown") {
          emit(AuthSuccessState(token: token, username: username));
        } else {
          emit(AuthErrorState("Token or username is missing."));
        }
      } else {
        emit(AuthErrorState(login.swap().getOrElse(() => 'Login failed')));
      }
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
