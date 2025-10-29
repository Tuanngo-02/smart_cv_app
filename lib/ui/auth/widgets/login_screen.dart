import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/themes/colors.dart';

enum LoginRole { jobSeeker, recruiter }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginRole _role = LoginRole.jobSeeker;
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _pwdCtl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  String get _title {
    return _role == LoginRole.jobSeeker
        ? 'Welcome Back Seeker'
        : 'Welcome Back Recruiter';
  }

  String get _subtitle => 'Sign in to continue your journey';

  @override
  void dispose() {
    _emailCtl.dispose();
    _pwdCtl.dispose();
    super.dispose();
  }

  void _switchRole(LoginRole r) {
    if (_role == r) return;
    setState(() => _role = r);
  }

  Future<void> _submit() async {
    context.go('/home');
    // if (!_formKey.currentState!.validate()) return;
    //
    // // Ví dụ xử lý login: ở đây chỉ mock đồng thời show Snackbar
    // setState(() => _loading = true);
    // await Future.delayed(const Duration(seconds: 1)); // giả lập network
    // setState(() => _loading = false);
    //
    // final roleStr = _role == LoginRole.jobSeeker ? 'Job Seeker' : 'Recruiter';
    // if (!mounted) return;
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Signed in as $roleStr: ${_emailCtl.text}')),
    // );
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
                        _buildRoleToggle(cs),
                        const SizedBox(height: 20),
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
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: const Icon(Icons.email),
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

                              // Forgot password + spacer
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

  Widget _buildRoleToggle(ColorScheme cs) {
    final selectedColor = cs.primary;
    final unselectedColor = cs.surfaceVariant ?? cs.onSurface.withOpacity(0.08);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _roleButton(
          label: 'Job Seeker',
          selected: _role == LoginRole.jobSeeker,
          onTap: () => _switchRole(LoginRole.jobSeeker),
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        ),
        const SizedBox(width: 12),
        _roleButton(
          label: 'Recruiter',
          selected: _role == LoginRole.recruiter,
          onTap: () => _switchRole(LoginRole.recruiter),
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
        ),
      ],
    );
  }

  Widget _roleButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? selectedColor : unselectedColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: selectedColor.withOpacity(0.16),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
