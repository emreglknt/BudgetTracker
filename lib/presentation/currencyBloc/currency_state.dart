part of 'currency_bloc.dart';

@immutable
sealed class CurrencyState {}

final class CurrencyInitial extends CurrencyState {}

class CurrencyLoadingState extends CurrencyState{}




class CurrencySuccessState extends CurrencyState{
  final double currency;
  CurrencySuccessState(this.currency);
}

class CurrencyErrorState extends CurrencyState{
  final String message;
  CurrencyErrorState(this.message);
}


class AddExpenseSuccessState extends CurrencyState{
  AddExpenseSuccessState();
}

