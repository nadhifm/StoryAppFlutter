import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:story_app/presentation/provider/splash_notifier.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SplashNotifier>(context, listen: false).getLoginStatus());

    Timer(
      const Duration(seconds: 2),
      () {
        final isLoggedIn =
            Provider.of<SplashNotifier>(context, listen: false).isLoggedIn;

        if (isLoggedIn) {
          context.goNamed('home');
        } else {
          context.goNamed('login');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Story App",
          style: GoogleFonts.poppins(
            fontSize: 32,
            color: const Color(0xFF1A3C40),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}