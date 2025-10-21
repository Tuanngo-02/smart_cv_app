import 'package:go_router/go_router.dart';

import '../ui/auth/widgets/login_screen.dart';
import '../ui/core/ui/welcome_screen.dart';
import '../ui/user/widgets/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],

  // errorBuilder: (context, state) => const NotFoundScreen(),
);