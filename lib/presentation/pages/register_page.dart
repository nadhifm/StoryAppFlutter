import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../common/state_enum.dart';
import '../provider/register_notifier.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
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
                "Daftar",
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
                controller: nameController,
                hint: "Nama",
                inputType: TextInputType.emailAddress,
                asset: "assets/ic_email.svg",
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
              context.watch<RegisterNotifier>().state == RequestState.Loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1A3C40),
                      ),
                    )
                  : PrimaryButton(
                      text: "Daftar",
                      onPressed: () => _onRegister(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _onRegister() async {
    FocusScope.of(context).unfocus();
    final registerNotifier = context.read<RegisterNotifier>();
    await registerNotifier.register(
      nameController.text,
      emailController.text,
      passwordController.text,
    );

    if (!mounted) return;

    final state = registerNotifier.state;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(registerNotifier.message),
      duration: const Duration(seconds: 1),
    ));
    if (state == RequestState.Loaded) {
      context.goNamed('login');
    }
  }
}
