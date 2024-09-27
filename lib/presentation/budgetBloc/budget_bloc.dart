import 'dart:async';
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

  //listener
  final _totalExpenseController = StreamController<double>.broadcast();
  Stream<double> get totalExpenseStream => _totalExpenseController.stream;


  BudgetBloc() : super(BudgetInitial()) {


    //add expense
    on<AddExpenseRequest>((event, emit) async {
      emit(BudgetLoadingState());
      var expense = await _mainRepo.addExpense(event.expense as double,event.category,event.date);
      expense.fold(
              (fail) => emit(BudgetErrorState(fail)),
            (expense) async {
              emit(AddBudgetSuccessState(expense)); // Success state for UI
              // Update the total expenses after adding the new one
              var totalExpense = await _mainRepo.getTotalExpenses();
              totalExpense.fold(
                (error) => emit(BudgetErrorState(error)),
                (total) => _totalExpenseController.add(total),  // Emit to stream
          );
        },
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



    on<GetTotalExpense>((event, emit) async {
      emit(BudgetLoadingState());
      var totalExpense = await _mainRepo.getTotalExpenses();
      totalExpense.fold(
              (error) => emit(BudgetErrorState(error)),
              (total) {
                emit(GetTotalSumExpenseSuccessState(total));
               _totalExpenseController.add(total); // Emit to stream for real-time updates
              },
      );
    });



  }

}
