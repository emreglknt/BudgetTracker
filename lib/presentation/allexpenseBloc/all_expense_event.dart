part of 'all_expense_bloc.dart';

@immutable
sealed class AllExpenseEvent {}




//all expense list
class GetAllExpense extends AllExpenseEvent{
  GetAllExpense();
}


//get expense by category filter
class GetAllExpenseByCategory extends AllExpenseEvent{
  final List<String> categoryList;
  GetAllExpenseByCategory({required this.categoryList});
}

