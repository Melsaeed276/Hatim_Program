import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hatim_program/controller/auth_controller.dart';
import 'package:provider/provider.dart';

import '../controller/contollers.dart';
import '../page_route.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context, listen: true)
        .getLanguage();
    final user = Provider.of<AuthController>(context, listen: true);

    //Theme
    final theme = Theme.of(context);

    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;


    /// Phone number
    /// Name
    return Scaffold(

      appBar: AppBar(
        title: Text('${lang.login!} ${lang.page!}'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(

          children: [

            if (!isKeyboardOpen)
              const Positioned(
                bottom: 3,
                right: 8,
                //App version
                child: Text('Version 1.0.7'),
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

                                      context.read<UserController>().userModel = value;

                                      AppRoutes.goToHome(context);


                                     // AppRoutes.goToHome(context);
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
    );
  }
}
