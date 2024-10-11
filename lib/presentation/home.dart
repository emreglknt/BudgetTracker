import 'dart:math';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:budget_family/data/model/expenseModel.dart';
import 'package:budget_family/presentation/login.dart';
import 'package:budget_family/presentation/statisticScreen.dart';
import 'package:budget_family/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_expense.dart';
import 'allexpensePage.dart';
import 'budgetBloc/budget_bloc.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController totalIncomeController = TextEditingController();


  @override
  void initState() {
    super.initState();
    final currentState = context.read<BudgetBloc>().state;
    if (currentState is! GetAllExpenseIncomeSuccessState) {
      context.read<BudgetBloc>().add(GetAllExpenseAndIncomeRequest());
    }
  }





  @override
  Widget build(BuildContext context) {

    final ScrollController scrollController = ScrollController();
    double totalIncome = 0.0;
    double totalExpense = 0.0;
    List<Expense> expenses = [];
    double totalBalance=0.0;
    String formattedBalance="";

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
            //MaterialPageRoute(builder: (context) =>  ExpenseStatistics( totalBalance:totalBalance)));
            MaterialPageRoute(builder: (context) =>  AddExpense()));

        },
        shape: const CircleBorder(),
        elevation: 7,
        backgroundColor: Colors.yellow[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),





      body: BlocListener<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if ( state is AddIncomeSuccessState) {
            context.read<BudgetBloc>().add(GetAllExpenseAndIncomeRequest());

          }
        },
        child: BlocBuilder<BudgetBloc, BudgetState>(
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


            if(state is AddIncomeSuccessState){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AnimatedSnackBar.material(
                  "Income Updated Successfully",
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  duration: const Duration(seconds: 4),
                ).show(context);
              });
            }


            if (state is GetAllExpenseIncomeSuccessState) {
              expenses = state.allExpenses;
              totalExpense = state.totalExpense;
              totalIncome = state.totalIncome;
              totalBalance = totalIncome-totalExpense;
              formattedBalance = totalBalance.toStringAsFixed(2);
            }



            return buildMainContent(totalIncome, totalExpense, expenses,formattedBalance);

          },
        ),
      ),
    );
  }





  Widget buildMainContent(double totalIncome, double totalExpense, List<Expense> expenses,String formattedBalance) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            _buildHeader(size),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildBalanceCard(totalExpense,totalIncome,formattedBalance),
                      const SizedBox(width: 15),
                      _buildBalanceCard2(totalIncome),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Add Income ➤',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTransactionHistoryHeader(),
                _buildViewAllExpenseHeader(totalExpense,totalIncome,formattedBalance),
              ],
            ),
            Expanded(
              child: _buildTransactionList(expenses),
            ),
          ],
        ),
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
                const SizedBox(height: 2),
                Text(
                  "${widget.username}",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.orange,
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
  Widget _buildBalanceCard(double totalExpense,double totalIncome,String formattedBalance) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0, left: 10.0, bottom: 7.0,),
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
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Total Balance',
                        style: TextStyle(fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    const SizedBox(height: 5),
                    Text('$formattedBalance ₺',
                        style: TextStyle(fontSize: 35,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    const SizedBox(height: 10),
                    _buildIncomeExpenseRow(totalExpense,totalIncome),
                  ],
                ),
                const Positioned(right: 15, top: 10,
                  child: Icon(
                    Icons.wallet,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




  //2. SECOND CARD
  //add expense and info card
  Widget _buildBalanceCard2(double totalIncome) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 200,
          width: 340,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff4B8DBB), Color(0xffD99BBA), Color(0xffF6B93B)],
              transform: const GradientRotation(pi / 4),
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45, blurRadius: 5, offset: Offset(5, 5)),
            ],
          ),
          child:  Padding(
            padding: EdgeInsets.only(left:20.0,top: 5),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Update Wallet',
                        style: TextStyle(fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),

                    const SizedBox(width: 15),

                    // text  total ıncome
                    Text('Total Income', style: TextStyle(fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white)),
                    Text("$totalIncome ₺", style: TextStyle(fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),



                    //button add income
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        elevation: 8,
                        shadowColor: Colors.black.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              title: const Text(
                                'Add Income',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.orangeAccent,
                                ),
                              ),
                              content: TextField(
                                controller: totalIncomeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Add Income',
                                  hintStyle: TextStyle(fontWeight: FontWeight.w300,color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.orangeAccent),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    totalIncome = double.parse(totalIncomeController.text);
                                    context.read<BudgetBloc>().add(AddIncomeRequest(income: totalIncome));
                                    totalIncomeController.clear();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Add',
                                    style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Add Income',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),



                    SizedBox(height: 10),

                  ],
                ),
                Positioned(right: 10, top:5 ,
                  child: Text(
                    "💳", style: TextStyle(fontSize: 30),
                  ),
                ),

            Positioned(
              right: 2,
              bottom: 5,
              child: Image.asset(
                'assets/bird.png', // replace with your coin image path
                height: 100,
                width: 135,
                fit: BoxFit.cover,
              ),
            ),


              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildIncomeExpenseRow(double totalExpense,double totalIncome) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIncomeWidget(totalIncome),
        _buildExpenseWidget(totalExpense),
      ],
    );
  }

  Widget _buildIncomeWidget(double totalIncome) {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Income', style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
            Text("$totalIncome ₺", style: TextStyle(fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildExpenseWidget(double totalExpense) {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Total Expense', style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
            Text("$totalExpense ₺", style: TextStyle(fontSize: 17,
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

  Widget _buildViewAllExpenseHeader(double totalExpense, double totalIncome, String formattedBalance) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllExpenseScreen(
                    totalExpense: totalExpense,
                    totalIncome: totalIncome,
                    totalBalance: formattedBalance,),
                ),

            );
          },
          child: Text(
            "View All",
            style: TextStyle(
              color: Colors.orangeAccent,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
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
                      fontWeight: FontWeight.w400,
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
