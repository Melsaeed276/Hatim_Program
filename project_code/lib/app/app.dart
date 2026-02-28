import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../features/auth/data/firebase_auth_repository.dart';
import '../features/auth/domain/auth_repository.dart';
import 'navigation/app_routes.dart';
import 'theme/app_theme.dart';

class HatimProgramApp extends StatefulWidget {
  const HatimProgramApp({this.authRepository, super.key});

  final AuthRepository? authRepository;

  @override
  State<HatimProgramApp> createState() => _HatimProgramAppState();
}

class _HatimProgramAppState extends State<HatimProgramApp> {
  Locale _locale = const Locale('en');
  late final AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _authRepository =
        widget.authRepository ??
        FirebaseAuthRepository(
          firebaseAuth: FirebaseAuth.instance,
          firestore: FirebaseFirestore.instance,
          googleSignIn: GoogleSignIn(scopes: const <String>['email']),
        );
  }

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hatim Program',
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('tr')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.buildLightTheme(_locale),
      onGenerateRoute: (settings) {
        return AppRoutes.onGenerateRoute(
          settings,
          authRepository: _authRepository,
          locale: _locale,
          onLocaleChanged: _setLocale,
        );
      },
      initialRoute: AppRoutes.login,
    );
  }
}
