import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/app/logging/app_logger.dart';

void main() {
  test('logger instance is safe before explicit initialization', () async {
    expect(() => AppLogger.instance.info('test message'), returnsNormally);
    await expectLater(
      AppLogger.instance.error('test error', error: Exception('boom')),
      completes,
    );
  });
}
