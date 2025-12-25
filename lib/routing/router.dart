import 'package:go_router/go_router.dart';

import '../ui/user/widgets/Upload_screen.dart';
import '../ui/user/widgets/profile_screen.dart';
import '../ui/user/widgets/my_files_screen.dart';
import '../ui/user/widgets/analysis_history_screen.dart';
import '../ui/auth/widgets/forgot_password_screen.dart';
import '../ui/auth/widgets/login_screen.dart';
import '../ui/auth/widgets/register_screen.dart';
import '../ui/core/ui/header_user_screen.dart';
import '../ui/core/ui/welcome_screen.dart';

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
    GoRoute(
      path: '/upload',
      name: 'upload',
      builder: (context, state) => const UploadScreen(),
    ),
    GoRoute(
      path: '/profile', 
      builder: (_, __) => const ProfileScreen()),
    GoRoute(
      path: '/my-files', 
      builder: (_, __) => const MyFilesScreen()),
    GoRoute(
      path: '/history', 
      builder: (_, __) => const AnalysisHistoryScreen()),
  ],

  // errorBuilder: (context, state) => const NotFoundScreen(),
);