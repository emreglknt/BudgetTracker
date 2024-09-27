import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:budget_family/data/model/expenseModel.dart';
import 'package:budget_family/data/repository/auth_repo.dart';
import 'package:meta/meta.dart';

import '../../data/repository/main_repo.dart';

part 'budget_event.dart';
part 'budget_state.dart';


class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final _mainRepo = MainRepository();
  final AuthRepository _authRepo = AuthRepository();

  BudgetBloc() : super(BudgetInitial()) {


    //add expense
    on<AddExpenseRequest>((event, emit) async {
      emit(BudgetLoadingState());
      var expense = await _mainRepo.addExpense(event.expense as double,event.category,event.date);
      expense.fold(
            (fail) => emit(BudgetErrorState(fail)),
            (expense) => emit(AddBudgetSuccessState(expense)) //success state
      );

    });

    on<ResetBudgetStateEvent>((event, emit) {
      emit(BudgetInitial()); // Bloc'u başlangıç durumuna döndür
    });


    // get user's All expenses
    on<GetAllExpenseRequest>((event,emit) async {
      emit(BudgetLoadingState());
      var allExpenses = await _mainRepo.getAllExpense();
      allExpenses.fold(
          (error) => emit(BudgetErrorState(error)),
          (expenses) => emit(GetAllExpenseSuccessState(expenses))  // başarılı durumda
      );
    });


    on<AuthLogoutRequest>((event,emit)async{
        await _authRepo.logout();
        emit(LogoutSuccessState());
    });






  }

}
