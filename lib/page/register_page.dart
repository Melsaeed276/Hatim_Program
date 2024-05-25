import 'package:flutter/material.dart';
import 'package:hatim_program/controller/auth_controller.dart';
import 'package:provider/provider.dart';

import '../controller/contollers.dart';
import '../page_route.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context, listen: true)
        .getLanguage();
    final userController = Provider.of<AuthController>(context, listen: true);

    //Theme
    final theme = Theme.of(context);

    /// Phone number
    /// Name
    return Scaffold(
      appBar: AppBar(
        title: Text('${lang.register!} ${lang.page!}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppRoutes.goBack(context);
          //    // go to login page with animation from left to right
          //   Navigator.pushReplacement(
          //     context,
          //     PageRouteBuilder(
          //       pageBuilder: (context, animation1, animation2) => AppRoutes.routes()[AppRoutes.login]!(context),
          //       transitionDuration: const Duration(milliseconds: 500),
          //       transitionsBuilder: (context, animation, animationTime, child) {
          //         animation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          //         return SlideTransition(
          //           position: Tween(begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
          //           child: child,
          //         );
          //       },
          //     ),
          //   );
           },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,

            // mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              // image from internet
              Center(
                child: Image.network(
                  'https://pbs.twimg.com/profile_images/1361681859516772352/ZyFPaMeQ_400x400.jpg',
                  width: 250,
                  height: 250,
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
                    autofocus: true,
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
                        // if (user.hasNumbers(value)) {
                        //   return lang.nameShouldNotContainNumbers;
                        // } else {
                          return null;

                      } else {
                        return '${lang.nameIsEmpty}, ${lang.pleaseEnterYourName}';
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
                      foregroundColor: userController.isPhoneNumberValid == true
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      backgroundColor: userController.isPhoneNumberValid == true
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      elevation: userController.isPhoneNumberValid == true ? 5.0 : 0.6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                       ///send the user data to repo and go to home
                        // send data to repo
                        userController.addUser().then((value) {
                          if (value != null) {
                            context.read<UserController>().userModel = value;
                            //Navigator.pushReplacementNamed(context, AppRoutes.home);
                            AppRoutes.goToHome(context);
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                  Text(lang.somethingWentWrong!)),
                            );
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text(lang.pleaseEnterYourName!)),
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
    );
  }
}
