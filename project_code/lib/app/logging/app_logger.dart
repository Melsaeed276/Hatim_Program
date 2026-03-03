import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._({required Logger logger, required bool crashlyticsEnabled})
    : _logger = logger,
      _crashlyticsEnabled = crashlyticsEnabled;

  static AppLogger? _instance;
  static AppLogger? _fallback;

  final Logger _logger;
  final bool _crashlyticsEnabled;

  static AppLogger get instance {
    final AppLogger? current = _instance ?? _fallback;
    if (current != null) {
      return current;
    }

    final Logger fallbackLogger = Logger(
      level: Level.debug,
      printer: PrettyPrinter(
        methodCount: 1,
        errorMethodCount: 2,
        lineLength: 100,
        colors: !kReleaseMode,
        printEmojis: !kReleaseMode,
      ),
      output: ConsoleOutput(),
    );
    _fallback = AppLogger._(logger: fallbackLogger, crashlyticsEnabled: false);
    return _fallback!;
  }

  static Future<void> initialize({required bool crashlyticsEnabled}) async {
    final Logger logger = Logger(
      level: kReleaseMode ? Level.warning : Level.debug,
      printer: PrettyPrinter(
        methodCount: 1,
        errorMethodCount: 5,
        lineLength: 100,
        colors: !kReleaseMode,
        printEmojis: !kReleaseMode,
      ),
      output: ConsoleOutput(),
    );

    bool enabled = false;
    if (crashlyticsEnabled) {
      try {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          true,
        );
        enabled = true;
      } catch (_) {
        enabled = false;
      }
    }

    _instance = AppLogger._(logger: logger, crashlyticsEnabled: enabled);
    _instance!.info(
      'Logger initialized',
      context: <String, Object?>{
        'crashlyticsEnabled': enabled,
        'releaseMode': kReleaseMode,
      },
    );
  }

  void trace(String message, {Map<String, Object?>? context}) {
    _logger.t(_buildMessage(message, context));
  }

  void debug(String message, {Map<String, Object?>? context}) {
    _logger.d(_buildMessage(message, context));
  }

  void info(String message, {Map<String, Object?>? context}) {
    _logger.i(_buildMessage(message, context));
    _logBreadcrumb(message, context);
  }

  void warning(String message, {Map<String, Object?>? context}) {
    _logger.w(_buildMessage(message, context));
    _logBreadcrumb(message, context);
  }

  Future<void> error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
    bool fatal = false,
  }) async {
    _logger.e(
      _buildMessage(message, context),
      error: error,
      stackTrace: stackTrace,
    );

    if (!_crashlyticsEnabled) {
      return;
    }

    try {
      await FirebaseCrashlytics.instance.recordError(
        error ?? message,
        stackTrace,
        reason: message,
        fatal: fatal,
        information: <DiagnosticsNode>[
          if (context != null)
            StringProperty('context', _contextToString(context)),
        ],
      );
    } catch (_) {}
  }

  Future<void> setUserIdentifier(String userId) async {
    final String safeUser = userId.trim();
    if (safeUser.isEmpty || !_crashlyticsEnabled) {
      return;
    }
    try {
      await FirebaseCrashlytics.instance.setUserIdentifier(safeUser);
    } catch (_) {}
  }

  Future<void> setCustomKey(String key, Object value) async {
    if (!_crashlyticsEnabled) {
      return;
    }
    try {
      await FirebaseCrashlytics.instance.setCustomKey(key, value);
    } catch (_) {}
  }

  String _buildMessage(String message, Map<String, Object?>? context) {
    if (context == null || context.isEmpty) {
      return message;
    }
    return '$message | ${_contextToString(context)}';
  }

  String _contextToString(Map<String, Object?> context) {
    return context.entries
        .map((MapEntry<String, Object?> entry) => '${entry.key}=${entry.value}')
        .join(' ');
  }

  void _logBreadcrumb(String message, Map<String, Object?>? context) {
    if (!_crashlyticsEnabled) {
      return;
    }

    final String text = _buildMessage(message, context);
    try {
      FirebaseCrashlytics.instance.log(text);
    } catch (_) {}
  }
}
