import 'package:flutter/material.dart';

import '../../../app/logging/app_logger.dart';
import '../../../app/theme/app_tokens.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user_profile.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    required this.authRepository,
    required this.onLoginPressed,
    required this.onAuthSuccess,
    super.key,
  });

  final AuthRepository authRepository;
  final VoidCallback onLoginPressed;
  final ValueChanged<AuthUserProfile> onAuthSuccess;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _referenceController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerWithPhone() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    AppLogger.instance.info('Register with phone started');

    try {
      final AuthUserProfile profile = await widget.authRepository
          .signUpWithPhone(
            name: _nameController.text,
            phoneNumber: _phoneController.text,
            referenceCode: _referenceController.text,
            password: _passwordController.text,
          );
      if (!mounted) {
        return;
      }
      AppLogger.instance.info(
        'Register with phone succeeded',
        context: <String, Object?>{'uid': profile.uid},
      );
      widget.onAuthSuccess(profile);
    } on AuthFailure catch (error) {
      AppLogger.instance.warning(
        'Register with phone failed',
        context: <String, Object?>{'code': error.code.name},
      );
      setState(() {
        _error = error.message;
      });
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        'Unexpected phone registration failure',
        error: error,
        stackTrace: stackTrace,
      );
      setState(() {
        _error = 'Registration failed unexpectedly.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  Future<void> _registerWithGoogle() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _error = 'Name is required before Google sign-up.';
      });
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    AppLogger.instance.info('Register with Google started');

    try {
      final AuthUserProfile profile = await widget.authRepository
          .signUpWithGoogle(
            name: _nameController.text,
            referenceCode: _referenceController.text,
            password: _passwordController.text,
          );
      if (!mounted) {
        return;
      }
      AppLogger.instance.info(
        'Register with Google succeeded',
        context: <String, Object?>{'uid': profile.uid},
      );
      widget.onAuthSuccess(profile);
    } on AuthFailure catch (error) {
      AppLogger.instance.warning(
        'Register with Google failed',
        context: <String, Object?>{'code': error.code.name},
      );
      setState(() {
        _error = error.message;
      });
    } catch (error, stackTrace) {
      AppLogger.instance.error(
        'Unexpected Google registration failure',
        error: error,
        stackTrace: stackTrace,
      );
      setState(() {
        _error = 'Google sign-up failed unexpectedly.';
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
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTokens.spaceLg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Create your account',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppTokens.spaceMd),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (String? value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Name is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTokens.spaceMd),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (String? value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Phone number is required for phone sign-up.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTokens.spaceMd),
              TextFormField(
                controller: _referenceController,
                decoration: const InputDecoration(
                  labelText: 'Reference Code (optional)',
                ),
              ),
              const SizedBox(height: AppTokens.spaceMd),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password (optional)',
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
                onPressed: _busy ? null : _registerWithPhone,
                child: Text(_busy ? 'Please wait...' : 'Sign Up with Phone'),
              ),
              const SizedBox(height: AppTokens.spaceMd),
              OutlinedButton(
                onPressed: _busy ? null : _registerWithGoogle,
                child: const Text('Sign Up with Google'),
              ),
              const SizedBox(height: AppTokens.spaceMd),
              TextButton(
                onPressed: _busy ? null : widget.onLoginPressed,
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
