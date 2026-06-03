import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/design_tokens.dart';
import '../providers/auth_provider.dart';
import '../widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'demo@smartsolutions.com');
  final _password = TextEditingController(text: 'demo1234');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final err = await auth.login(_email.text.trim(), _password.text);
    if (err != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final muted = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(AppRadius.card),
                boxShadow: AppShadows.card,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Gradient brand badge
                    Center(
                      child: Container(
                        height: 72,
                        width: 72,
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppShadows.card,
                        ),
                        child: const Icon(Icons.hub_rounded,
                            size: 38, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Smart Solutions',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Sign in to manage your office & IoT devices',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted)),
                    const SizedBox(height: AppSpacing.xl),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) =>
                          (v == null || v.length < 4) ? 'Min 4 characters' : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GradientButton(
                      label: 'Sign In',
                      loading: auth.loading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Center(
                      child: Text('demo@smartsolutions.com · demo1234',
                          style: TextStyle(color: muted, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
