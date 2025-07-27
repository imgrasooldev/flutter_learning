import 'package:flutter_learning/features/auth/views/register_page.dart';
import 'package:flutter_learning/features/provider/p_home_page.dart';
import 'package:flutter_learning/features/seeker/views/home_page.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/views/login_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterPage(),
      ), // 👈 NEW

      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
      GoRoute(
        path: '/provider_home',
        builder: (_, __) => const ProviderHomePage(),
      ),
    ],
  );
}
