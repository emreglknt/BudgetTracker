import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:budget_family/data/model/expenseModel.dart';
import 'package:budget_family/data/repository/auth_repo.dart';
import 'package:dartz/dartz.dart';
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
            (success){emit(AddExpenseSuccessState());},
      );
    });



    on<ResetBudgetStateEvent>((event, emit) {
      emit(BudgetInitial());
    });


    on<GetAllExpenseRequest>((event, emit) async {
      emit(BudgetLoadingState());

      await emit.forEach(
        _mainRepo.getAllExpense(),
        onData: (Either<String, Tuple2<List<Expense>, double>> result) => result.fold(
              (error) => BudgetErrorState(error),
              (expensesData) {
            List<Expense> expenses = expensesData.value1; // Harcama listesi
            double totalExpense = expensesData.value2;    // Toplam harcama
            return GetAllExpenseSuccessState(expenses, totalExpense);
          },
        ),
        onError: (_, __) => BudgetErrorState('Bir hata oluştu.'), // Olası hataları ele al
      );
    });



    on<AuthLogoutRequest>((event,emit)async{
      await _authRepo.logout();
      emit(LogoutSuccessState());
    });




  }

}
