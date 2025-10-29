import 'package:go_router/go_router.dart';

import '../ui/auth/widgets/forgot_password_screen.dart';
import '../ui/auth/widgets/login_screen.dart';
import '../ui/auth/widgets/register_screen.dart';
import '../ui/core/ui/header_user_screen.dart';
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
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgotPassword',
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HeaderUserScreen(),
    ),
  ],

  // errorBuilder: (context, state) => const NotFoundScreen(),
);