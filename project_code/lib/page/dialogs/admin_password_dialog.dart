import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';

class AdminPasswordDialog extends StatefulWidget {
  final String storedPassword;

  const AdminPasswordDialog({
    super.key,
    required this.storedPassword,
  });

  @override
  State<AdminPasswordDialog> createState() => _AdminPasswordDialogState();
}

class _AdminPasswordDialogState extends State<AdminPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _verifyPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate async verification
    await Future.delayed(const Duration(milliseconds: 300));

    // Trim whitespace from both entered and stored password for comparison
    final enteredPassword = _passwordController.text.trim();
    final storedPassword = widget.storedPassword.trim();

    if (kDebugMode) {
      print('Password verification:');
      print('Entered password length: ${enteredPassword.length}');
      print('Stored password length: ${storedPassword.length}');
      print('Passwords match: ${enteredPassword == storedPassword}');
    }

    // Verify password
    if (enteredPassword == storedPassword && enteredPassword.isNotEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop(true); // Return true on success
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = Provider.of<LocalizationController>(context, listen: false)
            .getLanguage()
            .adminPasswordIncorrect;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context, listen: true)
        .getLanguage();
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(lang.adminPanelText ?? 'Admin'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lang.adminPasswordPrompt ?? 'Please enter your admin password to continue',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: lang.password,
                  hintText: lang.pleaseEnterYourPassword,
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return lang.adminPasswordRequired;
                  }
                  return null;
                },
                enabled: !_isLoading,
                onFieldSubmitted: (_) => _verifyPassword(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.of(context).pop(false); // Return false on cancel
                },
          child: Text(lang.close ?? 'Close'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _verifyPassword,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(lang.continueText ?? 'Continue'),
        ),
      ],
    );
  }
}
