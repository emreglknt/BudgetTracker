import 'dart:math';
import 'package:budget_family/data/model/expenseModel.dart';
import 'package:budget_family/presentation/login.dart';
import 'package:budget_family/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_expense.dart';
import 'budgetBloc/budget_bloc.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(GetAllExpenseRequest());
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 4,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.indigo),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded, color: Colors.indigo),
              label: "Expense",
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddExpense()));
        },
        shape: const CircleBorder(),
        elevation: 7,
        backgroundColor: Colors.yellow[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<BudgetBloc, BudgetState>(
        builder: (context, state) {
          if (state is BudgetLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                strokeWidth: 2.0,
              ),
            );
          }
          if (state is LogoutSuccessState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            });
          }


          if (state is GetAllExpenseSuccessState) {
            // Harcama listesini al
            final expenses = state.allExpenses;

            return SafeArea(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                    children: [
                    _buildHeader(size),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row( // Row ile kartları yatay olarak yan yana diziyoruz
                      children: [
                        _buildBalanceCard(expenses),
                        const SizedBox(width: 20),
                        _buildBalanceCard2(expenses),
                      ],
                    ),
                  ),
                ),

                  const SizedBox(height: 15),
                  _buildTransactionHistoryHeader(),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<BudgetBloc>().add(GetAllExpenseRequest());
                      },
                      child: _buildTransactionList(expenses),
                    ),
                  ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text("No Data Available"));
        },
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigo,
                  ),
                ),
              ),
              Icon(Icons.person, color: Colors.white),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to BudgeT 👋",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  "${widget.username}",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout 👋🏻'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<BudgetBloc>().add(AuthLogoutRequest());
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },

            icon: const Icon(Icons.logout),
            color: Colors.indigo,
            iconSize: 30,
          ),
        ],
      ),
    );
  }




  // 1. FIRST CARD
  Widget _buildBalanceCard(List<Expense> expenses) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0,left: 10.0,bottom: 10.0,),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 200,
          width: 340,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff008C9E), Color(0xff9A59A1), Color(0xffFF6B20)],
              transform: const GradientRotation(pi / 4),
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45, blurRadius: 5, offset: Offset(5, 5)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Total Balance', style: TextStyle(fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
                const SizedBox(height: 5),
                Text('48000.00 ₺', style: TextStyle(fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
                const SizedBox(height: 10),
                _buildIncomeExpenseRow(expenses),
              ],
            ),
          ),
        ),
      ),
    );
  }



  //2. SECOND CARD
  //add expense and info card

  Widget _buildBalanceCard2(List<Expense> expenses) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 200,
          width: 340,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff008C9E), Color(0xff9A59A1), Color(0xffFF6B20)],
              transform: const GradientRotation(pi / 4),
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45, blurRadius: 5, offset: Offset(5, 5)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Total Balance', style: TextStyle(fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
                const SizedBox(height: 5),
                Text('48000.00 ₺', style: TextStyle(fontSize: 35,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
                const SizedBox(height: 10),
                _buildIncomeExpenseRow(expenses),
              ],
            ),
          ),
        ),
      ),
    );
  }










  Widget _buildIncomeExpenseRow(List<Expense> expenses) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIncomeWidget(),
        _buildExpenseWidget(expenses),
      ],
    );
  }

  Widget _buildIncomeWidget() {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
              color: Colors.white54, shape: BoxShape.circle),
          child: const Center(
            child: Icon(
                Icons.arrow_upward_rounded, color: Colors.green, size: 22),
          ),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Income', style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
            Text('20000.00 ₺', style: TextStyle(fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildExpenseWidget(List<Expense> expenses) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
              color: Colors.white54, shape: BoxShape.circle),
          child: const Center(
            child: Icon(
                Icons.arrow_downward_rounded, color: Colors.red, size: 22),
          ),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Total Expense', style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
            Text('68000.00 ₺', style: TextStyle(fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionHistoryHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Transactions History ˇ',
          style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<Expense> expenses) {
    return ListView.builder(
      itemCount: expenses.length, // Use the actual data count
      itemBuilder: (context, index) {
        final expense = expenses[index];
        final categoryData = getCategoryIconAndColor(expense.category);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black38, blurRadius: 4, offset: Offset(5, 4)),
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
                          Text(expense.date.toString(), style: TextStyle(
                              color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                  Text('-${expense.price} ₺', style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.indigo)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
