import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hatim_program/firebase_options.dart';

import 'app.dart';

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const HatimProgramApp());
}
