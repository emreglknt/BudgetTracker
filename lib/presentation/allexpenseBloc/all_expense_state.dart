part of 'all_expense_bloc.dart';

@immutable
sealed class AllExpenseState {}

final class AllExpenseInitial extends AllExpenseState {}



class ExpensesLoadingState extends AllExpenseState{}

class GetAllExpenseSuccessState extends AllExpenseState{
  final List<Expense> allExpenses;
  GetAllExpenseSuccessState(this.allExpenses);
}




class GetExpenseByCategorySuccess extends AllExpenseState{
  final List<Expense> expensesByCategory;
  GetExpenseByCategorySuccess(this.expensesByCategory);
}



class ErrorState extends AllExpenseState {
  final String error;
  ErrorState(this.error);
}

