part of 'currency_bloc.dart';

@immutable
sealed class CurrencyEvent {}


class GetCurrency extends CurrencyEvent{
  final String target;
  GetCurrency({required this.target});
}


class ResetBudgetStateEvent extends CurrencyEvent {}


class AddExpenseRequest extends CurrencyEvent {
  final double expense;
  final String category;
  final DateTime date;

  AddExpenseRequest({required this.expense,required this.category,required this.date,});
}
