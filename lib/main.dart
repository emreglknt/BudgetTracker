import 'package:budget_family/presentation/StatisticsBloc/statistics_bloc.dart';
import 'package:budget_family/presentation/allexpenseBloc/all_expense_bloc.dart';
import 'package:budget_family/presentation/authBloc/auth_bloc.dart';
import 'package:budget_family/presentation/budgetBloc/budget_bloc.dart';
import 'package:budget_family/presentation/currencyBloc/currency_bloc.dart';
import 'package:budget_family/presentation/login.dart';
import 'package:budget_family/utils/getIt.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getInit();
  runApp(const MyApp());
}


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
        BlocProvider(
          create: (context) => CurrencyBloc(),
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



