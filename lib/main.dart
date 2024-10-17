import 'package:budget_family/presentation/StatisticsBloc/statistics_bloc.dart';
import 'package:budget_family/presentation/allexpenseBloc/all_expense_bloc.dart';
import 'package:budget_family/presentation/authBloc/auth_bloc.dart';
import 'package:budget_family/presentation/budgetBloc/budget_bloc.dart';
import 'package:budget_family/presentation/currencyBloc/currency_bloc.dart';
import 'package:budget_family/presentation/splashScreen.dart';
import 'package:budget_family/utils/app_langugage_provider.dart';
import 'package:budget_family/utils/getIt.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getInit();
  final appLanguageProvider = AppLanguageProvider();
  await appLanguageProvider.fetchLocale();

  runApp(MyApp(appLanguageProvider: appLanguageProvider));
}

class MyApp extends StatelessWidget {
  final AppLanguageProvider appLanguageProvider;

  const MyApp({super.key, required this.appLanguageProvider});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => BudgetBloc()),
        BlocProvider(create: (context) => AllExpenseBloc()),
        BlocProvider(create: (context) => StatisticsBloc()),
        BlocProvider(create: (context) => CurrencyBloc()),
      ],
      child: ChangeNotifierProvider<AppLanguageProvider>.value(
        value: appLanguageProvider,
        child: Consumer<AppLanguageProvider>(
          builder: (context, provider, child) {
            return MaterialApp(
              locale: provider.appLocal,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''),
                Locale('tr', ''),
                Locale('de', ''),
              ],
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
