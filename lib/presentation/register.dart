import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authBloc/auth_bloc.dart';
import 'login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var d = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is RegisterLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AuthErrorState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AnimatedSnackBar.material(
                  state.error,
                  type: AnimatedSnackBarType.warning,
                  mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  duration: const Duration(seconds: 4),
                ).show(context);
              });
            }

            if (state is RegisterSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AnimatedSnackBar.material(
                d.user_signed_up_successfully,
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  duration: const Duration(seconds: 4),
                ).show(context);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
              });
            }

            return SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.33, // Ekranın %30'u kadar yükseklik
                      child: const Image(
                        image: AssetImage('assets/budget.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        d.welcome,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Username TextField
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: d.username,
                          hintStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                          prefixIcon: const Icon(Icons.account_circle_rounded),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Email TextField
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Password TextField
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: d.password,
                          hintStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Re-type Password TextField
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: rePasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: d.retype_password,
                          hintStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                          prefixIcon: const Icon(Icons.lock_reset_rounded),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Sign Up Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              usernameController.text.isEmpty ||
                              rePasswordController.text.isEmpty) {
                            AnimatedSnackBar.material(
                              d.please_fill_all_fields,
                              type: AnimatedSnackBarType.info,
                              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                              duration: const Duration(seconds: 4),
                            ).show(context);
                            return;
                          }

                          if (passwordController.text != rePasswordController.text) {
                            AnimatedSnackBar.material(
                              d.passwords_not_match,
                              type: AnimatedSnackBarType.warning,
                              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                              duration: const Duration(seconds: 4),
                            ).show(context);
                            return;
                          }

                          context.read<AuthBloc>().add(AuthRegisterRequest(
                              usernameController.text, emailController.text, passwordController.text));
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child:  Text(
                          d.sign_up,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                         d.have_an_account ,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child:  Text(
                            d.login,
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
