part of 'budget_bloc.dart';

@immutable
sealed class BudgetState {}

final class BudgetInitial extends BudgetState {}


class BudgetLoadingState extends BudgetState{}




class AddIncomeSuccessState extends BudgetState{
  final double totalIncome;
  AddIncomeSuccessState(this.totalIncome);
}



class GetAllExpenseIncomeSuccessState extends BudgetState{
  final List<Expense> allExpenses;
  final double totalExpense;
  final double totalIncome;
  GetAllExpenseIncomeSuccessState(this.allExpenses,this.totalExpense,this.totalIncome);
}




class BudgetErrorState extends BudgetState {
  final String error;
  BudgetErrorState(this.error);
}






class LogoutSuccessState extends BudgetState{}




