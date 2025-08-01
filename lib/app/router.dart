import 'package:flutter_learning/features/auth/views/register_page.dart';
import 'package:flutter_learning/features/auth/views/splash_page.dart';
import 'package:flutter_learning/features/provider/views/p_home_page.dart';
import 'package:flutter_learning/features/seeker/views/home_page.dart';
import 'package:flutter_learning/features/user/profile_page.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/views/login_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // start with splash
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
      GoRoute(
        path: '/provider_home',
        builder: (_, __) => const ProviderHomePage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}
