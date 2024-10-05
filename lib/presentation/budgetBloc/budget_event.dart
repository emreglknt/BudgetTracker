part of 'budget_bloc.dart';

@immutable
sealed class BudgetEvent {}



class ResetBudgetStateEvent extends BudgetEvent {}


  class AddExpenseRequest extends BudgetEvent {
    final double expense;
    final String category;
    final String date;

    AddExpenseRequest({required this.expense,required this.category,required this.date,});
  }

  // last10 expense total  income and expense
  class GetAllExpenseAndIncomeRequest extends BudgetEvent{
    GetAllExpenseAndIncomeRequest();
  }





class AddIncomeRequest extends BudgetEvent{
    final double income;
    AddIncomeRequest({required this.income});
}




// Gelir ve giderleri birleştiren yeni event
class UpdateBudgetRequest extends BudgetEvent {
  final double income;
  final double expense;
  final List<Expense> allExpenses;

  UpdateBudgetRequest({
    required this.income,
    required this.expense,
    required this.allExpenses,
  });
}



class AuthLogoutRequest extends BudgetEvent{}



