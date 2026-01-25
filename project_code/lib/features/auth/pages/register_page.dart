import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/controllers.dart';
import '../../../core/routing/page_route.dart';
import '../controllers/controllers.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(
      context,
      listen: true,
    ).getLanguage();
    final userController = Provider.of<AuthController>(context, listen: true);
    final authUserController = Provider.of<UserController>(context, listen: false);
    final isAuthenticated = authUserController.getCurrentUserID != '0';
    final theme = Theme.of(context);

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
        title: Text('${lang.register!} ${lang.page!}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppRoutes.goBack(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const SizedBox(height: 20),
              Center(
                child: Image.network(
                  'https://pbs.twimg.com/profile_images/1361681859516772352/ZyFPaMeQ_400x400.jpg',
                  width: 250,
                  height: 250,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  lang.appDescription!,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  controller: userController.nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: lang.pleaseEnterYourName,
                    labelText: lang.userName,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return '${lang.nameIsEmpty}, ${lang.pleaseEnterYourName}';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: userController.isPhoneNumberValid == true
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      backgroundColor: userController.isPhoneNumberValid == true
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      elevation: userController.isPhoneNumberValid == true
                          ? 5.0
                          : 0.6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        userController.addUser().then((value) {
                              if (value != null) {
                                context.read<UserController>().userModel =
                                    value;
                                AppRoutes.goToHome(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(lang.somethingWentWrong!),
                                  ),
                                );
                              }
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(lang.pleaseEnterYourName!)),
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
    );
  }
}
