import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../data/model/expenseModel.dart';
import '../../data/repository/main_repo.dart';

part 'all_expense_event.dart';
part 'all_expense_state.dart';

class AllExpenseBloc extends Bloc<AllExpenseEvent, AllExpenseState> {

  final _mainRepo = MainRepository();

  AllExpenseBloc() : super(AllExpenseInitial()) {



    //get all expense list
    on<GetAllExpense>((event,emit)async{
      emit(ExpensesLoadingState());
      await emit.forEach(
          _mainRepo.getAllExpenses(),
          onData: (Either<String, List<Expense>> result) => result.fold(
                (error) => ErrorState(error),
                (expenses) => GetAllExpenseSuccessState(expenses),
          ),
          onError: (_, __) => ErrorState('Bir hata oluştu.')
      );
    });






    //get  expense list by category
    on<GetAllExpenseByCategory>((event,emit)async{
      emit(ExpensesLoadingState());
      await emit.forEach(
          _mainRepo.getExpensesByCategory(event.categoryList),
          onData: (Either<String, List<Expense>> result) => result.fold(
                (error) => ErrorState(error),
                (expensesByCategory) => GetExpenseByCategorySuccess(expensesByCategory),
          ),
          onError: (_, __) => ErrorState('Bir hata oluştu.')
      );
    });





  }
}
