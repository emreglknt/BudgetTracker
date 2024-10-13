import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../data/model/expenseModel.dart';
import '../utils/utils.dart';
import 'allexpenseBloc/all_expense_bloc.dart';

class AllExpenseScreen extends StatefulWidget {
  final double totalExpense;
  final double totalIncome;
  final String totalBalance;

  const AllExpenseScreen({
    Key? key,
    required this.totalExpense,
    required this.totalIncome,
    required this.totalBalance,
  }) : super(key: key);

  @override
  State<AllExpenseScreen> createState() => _AllExpenseScreenState();
}

class _AllExpenseScreenState extends State<AllExpenseScreen> {

  @override
  void initState() {
    super.initState();
    context.read<AllExpenseBloc>().add(GetAllExpense());
  }



  @override
  Widget build(BuildContext context) {

    //for filtering opitons

    final List<String> selectedCategories = [];





    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.indigo),
        ),
        title: Text('All Expenses'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {

              // Open filter options
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.7,
                    child: StatefulBuilder(
                      builder: (context, setModalState) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               const  Padding(
                                  padding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 10.0),
                                  child: const Text(
                                    'Select Categories',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 5.0,
                                  runSpacing: 3.0,
                                  children: categories.map((category) {
                                    return FilterChip(
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(category['icon'], size: 18, color: category['color']),
                                          SizedBox(width: 5),
                                          Text(category['name']),
                                        ],
                                      ),
                                      backgroundColor: category['color'].withOpacity(0.15),
                                      selectedColor: category['color'].withOpacity(0.75),
                                      selected: selectedCategories.contains(category['name']),
                                      onSelected: (isSelected) {
                                        setModalState(() {
                                          if (isSelected) {
                                            if (selectedCategories.length < 7) {
                                              selectedCategories.add(category['name']);
                                            } else {
                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                AnimatedSnackBar.material(
                                                "You can select up to 8 categories only.",
                                                  type: AnimatedSnackBarType.warning,
                                                  mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                                                  duration: const Duration(seconds: 4),
                                                ).show(context);
                                              });
                                            }
                                          }  else {
                                            selectedCategories.remove(category['name']);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),
                                const Divider(),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if(selectedCategories.isEmpty){
                                        context.read<AllExpenseBloc>().add(GetAllExpense());
                                      }
                                      context.read<AllExpenseBloc>().add(GetAllExpenseByCategory(categoryList: selectedCategories));
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 7,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      backgroundColor: Colors.blue,
                                    ),
                                    child: const Text(
                                      'Apply Filters',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );

            },
          ),
        ],
      ),
      body: BlocBuilder<AllExpenseBloc, AllExpenseState>(
        builder: (context, state) {

          List<Expense> expenses = [];

          if(state is ExpensesLoadingState){
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                strokeWidth: 2.0,
              ),
            );
          }


          if(state is GetAllExpenseSuccessState){
            expenses = state.allExpenses;
          }


          //category
          if(state is GetExpenseByCategorySuccess){
            expenses = state.expensesByCategory;
            if(expenses.isEmpty){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AnimatedSnackBar.material(
                  "You do not have any expenses in this category.",
                  type: AnimatedSnackBarType.warning,
                  mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  duration: const Duration(seconds: 5),
                ).show(context);
              });
              context.read<AllExpenseBloc>().add(GetAllExpense());
            }
          }






          return SafeArea(
            child: Column(
              children: [

                Expanded(
                    child: ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        final categoryData = getCategoryIconAndColor(expense.category);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black38, blurRadius: 4, offset: Offset(3, 5)),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: categoryData['color'],
                                        ),
                                        child: Center(
                                          child: Icon(categoryData['icon'],
                                              color: Colors.white), // Dynamic icon
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(expense.category, style: const TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 5),
                                          Text(DateFormat('dd-MMMM-yyyy ').format(expense.date), style: TextStyle(
                                            color: Colors.grey[600],
                                          )),
                                          Text(DateFormat('HH:mm').format(expense.date), style: TextStyle(
                                            color: Colors.grey[600],
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text('-${expense.price} ₺', style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.indigo)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Income',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${widget.totalIncome.toString()} ₺',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 const Text(
                    'Total Expense',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${widget.totalExpense.toString()} ₺',
                    style:const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${widget.totalBalance.toString()} ₺',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}
