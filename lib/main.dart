import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hatim_program/controller/auth_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'controller/contollers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    // web is not supported in path provider
    await Hive.initFlutter();
  } else {

    final Directory dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
  }
  await Hive.openBox('theme');
  await Hive.openBox('language');
  await Hive.openBox('route');
  await Hive.openBox('group');
  await Hive.openBox('user');
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  await FirebaseAnalytics.instance.logAppOpen();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocalizationController()),
        ChangeNotifierProvider(create: (context) => ConnectionController()),
        ChangeNotifierProvider(create: (context) => UserController()),
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => GroupController()),

      ],
      child: const App(),
    ),
  );
}

