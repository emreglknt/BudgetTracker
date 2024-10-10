import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/repository/main_repo.dart';
import '../budgetBloc/budget_bloc.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(CurrencyInitial()) {
    final _mainRepo = MainRepository();



    //add expense
    on<AddExpenseRequest>((event, emit) async {
      emit(CurrencyLoadingState());
      var expense = await _mainRepo.addExpense(event.expense,event.category,event.date);
      expense.fold(
            (fail) => emit(CurrencyErrorState(fail)),
            (success){emit(AddExpenseSuccessState());},
      );
    });


    on<ResetBudgetStateEvent>((event, emit) {
      emit(CurrencyInitial());
    });






    // get currency
    on<GetCurrency>((event, emit) async {
      emit(CurrencyLoadingState());
      try {
        final currency = await _mainRepo.getCurrency(event.target);
        currency.fold(
              (error) {emit(CurrencyErrorState(error));},
              (currencyExchangeRate) { emit(CurrencySuccessState(currencyExchangeRate));},
        );
      } catch (error) {
        emit(CurrencyErrorState(error.toString()));
      }
    });



  }
}
