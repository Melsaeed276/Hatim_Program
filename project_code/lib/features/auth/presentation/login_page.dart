import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user_profile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.authRepository,
    required this.onRegisterPressed,
    required this.onAuthSuccess,
    super.key,
  });

  final AuthRepository authRepository;
  final VoidCallback onRegisterPressed;
  final ValueChanged<AuthUserProfile> onAuthSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithPhone() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final AuthUserProfile profile = await widget.authRepository
          .loginWithPhone(
            phoneNumber: _phoneController.text,
            password: _passwordController.text,
          );
      if (!mounted) {
        return;
      }
      widget.onAuthSuccess(profile);
    } on AuthFailure catch (error) {
      setState(() {
        _error = error.message;
      });
    } catch (_) {
      setState(() {
        _error = 'Login failed unexpectedly.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final AuthUserProfile profile = await widget.authRepository
          .loginWithGoogle();
      if (!mounted) {
        return;
      }
      widget.onAuthSuccess(profile);
    } on AuthFailure catch (error) {
      setState(() {
        _error = error.message;
      });
    } catch (_) {
      setState(() {
        _error = 'Google login failed unexpectedly.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTokens.spaceLg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppTokens.spaceMd),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (String? value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Phone number is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTokens.spaceMd),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password (only if account has password)',
                ),
                obscureText: true,
              ),
              const SizedBox(height: AppTokens.spaceLg),
              if (_error != null) ...<Widget>[
                Text(
                  _error!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: AppTokens.spaceLg),
              ],
              FilledButton(
                onPressed: _busy ? null : _loginWithPhone,
                child: Text(_busy ? 'Please wait...' : 'Login with Phone'),
              ),
              const SizedBox(height: AppTokens.spaceMd),
              OutlinedButton(
                onPressed: _busy ? null : _loginWithGoogle,
                child: const Text('Login with Google'),
              ),
              const SizedBox(height: AppTokens.spaceMd),
              TextButton(
                onPressed: _busy ? null : widget.onRegisterPressed,
                child: const Text('No account yet? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
