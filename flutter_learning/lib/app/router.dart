import 'package:go_router/go_router.dart';

import '../features/auth/views/login_page.dart';
import '../features/home/views/home_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/home', builder: (_, __) => const HomePage()),
    ],
  );
}
