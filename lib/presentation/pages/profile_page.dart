import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/state_enum.dart';
import 'package:story_app/presentation/provider/profile_notifier.dart';
import 'package:story_app/presentation/widgets/primary_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProfileNotifier>(context, listen: false)
            .getUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: Consumer<ProfileNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return const CircularProgressIndicator(
                color: Color(0xFF1A3C40),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 150),
                  Text(
                    data.user.name,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A3C40),
                    ),
                  ),
                  Text(
                    data.user.email,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1A3C40),
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PrimaryButton(
                      text: "Logout",
                      onPressed: () async{
                        await data.logout();

                        if (!mounted) return;

                        context.goNamed("login");
                      },
                    ),
                  ),
                ],
              );
            }
          },
        )),
      ),
    );
  }
}
