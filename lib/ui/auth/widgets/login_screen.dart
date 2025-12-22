import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/themes/colors.dart';

// Đã xóa enum LoginRole vì chỉ còn 1 vai trò

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _pwdCtl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  // Tiêu đề cố định cho Job Seeker
  String get _title => 'Welcome Back Seeker';
  String get _subtitle => 'Sign in to continue your journey';

  @override
  void dispose() {
    _emailCtl.dispose();
    _pwdCtl.dispose();
    super.dispose();
  }

  // Đã xóa hàm _switchRole

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return; // Thêm validate check trước khi submit

    setState(() => _loading = true); // Cập nhật trạng thái loading

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtl.text.trim(),
        password: _pwdCtl.text.trim(),
      );

      if (mounted) {
        context.go('/home');
      }

    } on FirebaseAuthException catch (e) {
      var message = '';
      switch (e.code) {
        case 'invalid-email':
          message = 'Email không hợp lệ.';
          break;
        case 'user-not-found':
          message = 'Người dùng không tồn tại.';
          break;
        case 'wrong-password':
          message = 'Mật khẩu sai.';
          break;
        default:
          message = 'Đăng nhập thất bại: ${e.message}';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Có lỗi xảy ra, thử lại sau')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bg1, AppColors.bg2],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Đã xóa _buildRoleToggle
                        const SizedBox(height: 10),

                        Text(
                          _title,
                          style: Theme.of(context).textTheme.headlineLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _subtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        // --- Form
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailCtl,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Hãy nhập email';
                                  }
                                  if (!RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+$',
                                  ).hasMatch(v)) {
                                    return 'Email không hợp lệ';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _pwdCtl,
                                obscureText: _obscure,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () =>
                                        setState(() => _obscure = !_obscure),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Hãy nhập mật khẩu';
                                  }
                                  if (v.length < 6) {
                                    return 'Mật khẩu phải ít nhất 6 ký tự';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 12),

                              // Forgot password
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context.go('/forgotPassword');
                                    },
                                    child: const Text('Forgot password?'),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Sign in button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cs.primary,
                                    foregroundColor: cs.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _loading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'Sign In',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                color: cs.onPrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Sign up hint
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Don\'t have an account? '),
                                  TextButton(
                                    onPressed: () {
                                      context.go('/register');
                                    },
                                    child: const Text('Sign Up'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
