import 'package:budget_family/presentation/StatisticsBloc/statistics_bloc.dart';
import 'package:budget_family/presentation/add_expense.dart';
import 'package:budget_family/presentation/allexpenseBloc/all_expense_bloc.dart';
import 'package:budget_family/presentation/authBloc/auth_bloc.dart';
import 'package:budget_family/presentation/budgetBloc/budget_bloc.dart';
import 'package:budget_family/presentation/home.dart';
import 'package:budget_family/presentation/login.dart';
import 'package:budget_family/presentation/statisticScreen.dart';
import 'package:budget_family/utils/auth_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
// main.dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => BudgetBloc(),
        ),
        BlocProvider(
          create: (context) => AllExpenseBloc(),
        ),
        BlocProvider(
          create: (context) => StatisticsBloc(),
        ),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}



