part of 'budget_bloc.dart';

@immutable
sealed class BudgetState {}

final class BudgetInitial extends BudgetState {}


class BudgetLoadingState extends BudgetState{}



class AddExpenseSuccessState extends BudgetState{
  AddExpenseSuccessState();
}





class GetAllExpenseSuccessState extends BudgetState{
  final List<Expense> allExpenses;
  final double totalExpense;
  GetAllExpenseSuccessState(this.allExpenses,this.totalExpense);
}


class GetTotalSumExpenseSuccessState extends BudgetState{
  final double totalSumExpense;
  GetTotalSumExpenseSuccessState(this.totalSumExpense);
}




class BudgetErrorState extends BudgetState {
  final String error;
  BudgetErrorState(this.error);
}



class LogoutSuccessState extends BudgetState{}




