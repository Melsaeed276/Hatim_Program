import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hatim_program/firebase_options.dart';

import 'logging/app_logger.dart';
import 'app.dart';

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppLogger.initialize(crashlyticsEnabled: kReleaseMode || kProfileMode);

  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.instance.error(
      'Flutter framework error',
      error: details.exception,
      stackTrace: details.stack,
      fatal: true,
      context: <String, Object?>{'library': details.library},
    );
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
    unawaited(
      AppLogger.instance.error(
        'Uncaught platform error',
        error: error,
        stackTrace: stackTrace,
        fatal: true,
      ),
    );
    return true;
  };

  runZonedGuarded(
    () {
      AppLogger.instance.info('Starting Hatim Program app');
      runApp(const HatimProgramApp());
    },
    (Object error, StackTrace stackTrace) {
      unawaited(
        AppLogger.instance.error(
          'Uncaught zone error',
          error: error,
          stackTrace: stackTrace,
          fatal: true,
        ),
      );
    },
  );
}
