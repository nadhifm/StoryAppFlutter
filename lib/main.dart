import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/presentation/pages/add_story_page.dart';
import 'package:story_app/presentation/pages/detail_story_page.dart';
import 'package:story_app/presentation/pages/home_page.dart';
import 'package:story_app/presentation/pages/login_page.dart';
import 'package:story_app/presentation/pages/main_page.dart';
import 'package:story_app/presentation/pages/map_page.dart';
import 'package:story_app/presentation/pages/profile_page.dart';
import 'package:story_app/presentation/pages/register_page.dart';
import 'package:story_app/presentation/pages/splash_page.dart';
import 'package:story_app/presentation/provider/add_story_notifier.dart';
import 'package:story_app/presentation/provider/login_notifier.dart';
import 'package:story_app/presentation/provider/profile_notifier.dart';
import 'package:story_app/presentation/provider/register_notifier.dart';
import 'package:story_app/presentation/provider/splash_notifier.dart';
import 'package:story_app/presentation/provider/story_list_notifier.dart';
import 'injection.dart' as di;

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: ((context, state) {
          return const SplashPage();
        }),
      ),
      GoRoute(
          path: '/login',
          name: 'login',
          builder: ((context, state) {
            return const LoginPage();
          }),
          routes: [
            GoRoute(
              path: 'register',
              name: 'register',
              builder: ((context, state) {
                return const RegisterPage();
              }),
            ),
          ]),
      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: ((context, state, child) {
            return MainPage(child: child);
          }),
          routes: [
            GoRoute(
                path: '/home',
                name: 'home',
                builder: ((context, state) {
                  return const HomePage();
                }),
                routes: [
                  GoRoute(
                    path: 'add-story',
                    name: 'add-story',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: ((context, state) {
                      return const AddStoryPage();
                    }),
                    routes: [
                      GoRoute(
                        path: 'map',
                        name: 'map',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: ((context, state) {
                          return const MapPage();
                        }),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'detail-story',
                    name: 'detail-story',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: ((context, state) {
                      final story = state.extra;
                      if (story != null && story is Story) {
                        return DetailStoryPage(story: story);
                      } else {
                        return const HomePage();
                      }
                    }),
                  ),
                ]),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: ((context, state) {
                return const ProfilePage();
              }),
            ),
          ])
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<SplashNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<LoginNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<RegisterNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<StoryListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<ProfileNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<AddStoryNotifier>(),
        )
      ],
      child: MaterialApp.router(
        title: 'Story App',
        routerConfig: router,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFEDE6DB),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0x40417D7A)),
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF1A3C40)),
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
        ),
      ),
    );
  }
}
