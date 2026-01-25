import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/controllers.dart';
import '../../../core/localization/lang/localization.dart';
import '../../../core/routing/page_route.dart';
import '../controllers/controllers.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  Future<bool?> _showPasswordDialog({
    required BuildContext context,
    required Localization localization,
    required String title,
    required String description,
    required String? storedPassword,
  }) {
    final dialogFormKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final loc = localization;
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: dialogFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(description),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: loc.password ?? 'Password',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.pleaseEnterYourPassword ??
                          'Please enter your password';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(loc.close ?? 'Close'),
            ),
            FilledButton(
              onPressed: () {
                if (!(dialogFormKey.currentState?.validate() ?? false)) {
                  return;
                }

                final input = passwordController.text;
                final isMatch = storedPassword == null || input == storedPassword;

                if (!isMatch) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        loc.wrongPasswordMessage ?? 'Authentication failed',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop(true);
              },
              child: Text(loc.continueText ?? 'Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context, listen: true)
        .getLanguage();
    final user = Provider.of<AuthController>(context, listen: true);
    final userController = Provider.of<UserController>(context, listen: false);
    final isAuthenticated = userController.getCurrentUserID != '0';

    //Theme
    final theme = Theme.of(context);

    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;


    /// Phone number
    /// Name
    return PopScope(
      // Prevent back navigation if user is authenticated (shouldn't happen due to redirect, but safety check)
      canPop: !isAuthenticated,
      onPopInvoked: (didPop) {
        if (isAuthenticated && didPop) {
          // If authenticated and back button was pressed, navigate to home instead
          AppRoutes.goToHome(context);
        }
      },
      child: Scaffold(

      appBar: AppBar(
        title: Text('${lang.login!} ${lang.page!}'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(

          children: [

            if (!isKeyboardOpen)
              Positioned(
                bottom: 3,
                right: 8,
                //App version
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text('${lang.version!} ${snapshot.data!.version}');
                    }
                    return Text('${lang.version!} ...');
                  },
                ),
              ),

            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // image from internet
                      Center(
                        child: Image.network(
                          'https://pbs.twimg.com/profile_images/1361681859516772352/ZyFPaMeQ_400x400.jpg',
                          width: 200,
                          height: 200,
                        ),
                      ),

                      //sized box
                      const SizedBox(
                        height: 20,
                      ),
                      // text
                      Center(
                        child: Text(
                          lang.appDescription!,
                          style: theme.textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            // make the focus to be on the phone number
                            //autofocus: true,
                            focusNode: _focusNode,
                            maxLength: 10,
                            onTap: () {
                              _focusNode.requestFocus();
                            },
                            controller: user.phoneNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.phone),
                              hintText: lang.pleaseEnterYourPhoneNumber,
                              labelText: lang.phoneNumber,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onChanged: (value) {
                              user.isPhoneNumberValidChecker();
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!value.startsWith('5')) {
                                  return lang.phoneNumberShouldStartWith5;
                                } else if (value.length != 10) {
                                  return lang.phoneNumberShouldBe10Digits;
                                } else {
                                  return null;
                                }
                              } else {
                                return lang.pleaseEnterYourPhoneNumber;
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50.0,
                          child: ElevatedButton(
                            //if the phone number is valid show change the button color if not make it green
                            style: ElevatedButton.styleFrom(
                              foregroundColor: user.isPhoneNumberValid == true
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                              backgroundColor: user.isPhoneNumberValid == true
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surface,
                              elevation: user.isPhoneNumberValid == true ? 5.0 : 0.6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (user.isPhoneNumberValid) {
                                  /// check the repo if the user phone number is exit
                                  /// if it is exist go to the next page
                                  /// if not exist  go to register the user page
                                  await user.getUserByPhoneNumber().then((value)  async {
                                    if (value != null) {
                                      if (kDebugMode) {
                                        print('User found: ${value.name}');
                                        print('Is Admin: ${value.isAdmin}');
                                        print('Has Password: ${value.adminPassword != null && value.adminPassword!.isNotEmpty}');
                                        if (value.adminPassword != null) {
                                          print('Password length: ${value.adminPassword!.length}');
                                        }
                                      }
                                      
                                      // Check if user has password (admin or regular user)
                                      if ((value.isAdmin && value.adminPassword != null && value.adminPassword!.isNotEmpty) ||
                                          (!value.isAdmin && value.password != null && value.password!.isNotEmpty)) {
                                        if (kDebugMode) {
                                          print('Showing password dialog for user: ${value.isAdmin ? 'admin' : 'regular user'}');
                                        }

                                        String dialogTitle = value.isAdmin ? 'Admin Authentication' : 'Enter Password';
                                        String dialogDescription = value.isAdmin
                                            ? 'Please enter your admin password to continue.'
                                            : 'Please enter your password to continue.';
                                        String? storedPassword = value.isAdmin ? value.adminPassword : value.password;

                                        // Show password dialog
                                        final passwordVerified = await _showPasswordDialog(
                                          context: context,
                                          localization: lang,
                                          title: dialogTitle,
                                          description: dialogDescription,
                                          storedPassword: storedPassword,
                                        );

                                        if (kDebugMode) {
                                          print('Password verified result: $passwordVerified');
                                        }

                                        if (passwordVerified == true) {
                                          // Password verified, proceed to home
                                          if (context.mounted) {
                                            final userController = context.read<UserController>();
                                            if (value.isAdmin) {
                                              userController.setAdminPasswordVerified = true;
                                            } else {
                                              userController.clearAdminPasswordVerification();
                                            }
                                            userController.userModel = value;
                                            AppRoutes.goToHome(context);
                                          }
                                        } else {
                                          // Password verification failed or cancelled
                                          // Don't navigate, stay on login page
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(lang.wrongPasswordMessage ?? 'Authentication failed'),
                                              ),
                                            );
                                          }
                                        }
                                      } else {
                                        // No password set, proceed normally
                                        final userController = context.read<UserController>();
                                        userController.clearAdminPasswordVerification();
                                        userController.userModel = value;
                                        AppRoutes.goToHome(context);
                                      }
                                    } else {
                                      AppRoutes.goToRegister(context);
                                    }
                                  });

                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(lang.phoneNumberValidationMessage!)),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text(lang.phoneNumberValidationMessage!)),
                                );
                              }
                            },
                            child: Text(lang.continueText!),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
