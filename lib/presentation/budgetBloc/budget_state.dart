part of 'budget_bloc.dart';

@immutable
sealed class BudgetState {}

final class BudgetInitial extends BudgetState {}


class BudgetLoadingState extends BudgetState{}



class AddBudgetSuccessState extends BudgetState{
  final dynamic expense;
  AddBudgetSuccessState(this.expense);
}



class GetAllExpenseSuccessState extends BudgetState{
  final List<Expense> allExpenses;
  GetAllExpenseSuccessState(this.allExpenses);
}






class BudgetErrorState extends BudgetState {
  final String error;
  BudgetErrorState(this.error);
}



class LogoutSuccessState extends BudgetState{}




