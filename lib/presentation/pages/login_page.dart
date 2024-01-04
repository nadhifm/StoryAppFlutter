import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:story_app/presentation/provider/login_notifier.dart';
import 'package:go_router/go_router.dart';

import '../../common/state_enum.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masuk",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A3C40),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                controller: emailController,
                hint: "Email",
                inputType: TextInputType.emailAddress,
                asset: "assets/ic_email.svg",
              ),
              const SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                controller: passwordController,
                hint: "Password",
                inputType: TextInputType.visiblePassword,
                asset: "assets/ic_password.svg",
              ),
              const SizedBox(
                height: 24.0,
              ),
              context.watch<LoginNotifier>().state == RequestState.Loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1A3C40),
                      ),
                    )
                  : PrimaryButton(
                      text: "Masuk",
                      onPressed: () => _onLogin(),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum memiliki akun?",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1A3C40),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        context.goNamed('register');
                      },
                      child: Text(
                        'Daftar',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A3C40),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _onLogin() async {
    FocusScope.of(context).unfocus();
    final loginNotifier = context.read<LoginNotifier>();
    await loginNotifier.login(
      emailController.text,
      passwordController.text,
    );

    if (!mounted) return;
    
    final state = loginNotifier.state;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(loginNotifier.message),
      duration: const Duration(seconds: 1),
    ));
    if (state == RequestState.Loaded) {
      context.goNamed('home');
    }
  }
}
