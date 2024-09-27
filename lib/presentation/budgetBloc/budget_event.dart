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


  class GetAllExpenseRequest extends BudgetEvent{
    GetAllExpenseRequest();
  }



class AuthLogoutRequest extends BudgetEvent{}

