import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:budget_family/presentation/home.dart';
import 'package:budget_family/presentation/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'authBloc/auth_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var d = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AuthErrorState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AnimatedSnackBar.material(
                  state.error,
                  type: AnimatedSnackBarType.error,
                  mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  duration: const Duration(seconds: 4),
                ).show(context);
              });
            }

            if (state is AuthSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AnimatedSnackBar.material(
                  d.logged_in_successfully, // Çeviri kullanımı
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  duration: const Duration(seconds: 4),
                ).show(context);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              });
            }

            return SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.36,
                      width: size.width,
                      child: Lottie.asset('assets/finance.json'),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        d.welcome, // 'Welcome to Budge🆃' yerine
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: size.height * 0.06),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          d.login_to_your_account, // 'Login to your account' yerine
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: "E-mail",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: const Icon(Icons.email),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: d.password, // 'Password' yerine
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                            AnimatedSnackBar.material(
                              d.please_fill_all_fields,
                              type: AnimatedSnackBarType.warning,
                              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                              duration: const Duration(seconds: 3),
                            ).show(context);
                            return;
                          } else {
                            context.read<AuthBloc>().add(
                              AuthLoginRequest(_emailController.text, _passwordController.text),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          textStyle: const TextStyle(fontSize: 19, color: Colors.white),
                        ),
                        child: Text(
                          d.login, // 'Login' yerine
                          style: const TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          d.dont_have_an_account,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: Text(
                            d.create_account,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.blue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
