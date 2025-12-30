class SecurityService {
  // Rate limiting for group creation
  static final Map<String, List<DateTime>> _creationAttempts = {};
  static const int _maxAttemptsPerHour = 10;
  static const Duration _rateLimitWindow = Duration(hours: 1);

  // Input sanitization methods
  static String sanitizeGroupName(String input) {
    // Remove potentially harmful characters and trim
    return input
        .replaceAll(RegExp(r'[<>"/\\|?*\x00-\x1f]'), '') // Remove dangerous chars
        .trim()
        .substring(0, input.length > 100 ? 100 : input.length); // Limit length
  }

  static String sanitizeGroupID(String input) {
    // Only allow digits and ensure exactly 6 characters
    final sanitized = input.replaceAll(RegExp(r'[^0-9]'), '');
    return sanitized.length == 6 ? sanitized : '';
  }

  // Rate limiting check
  static bool canCreateGroup(String userId) {
    final now = DateTime.now();
    final userAttempts = _creationAttempts[userId] ?? [];

    // Remove attempts outside the time window
    final validAttempts = userAttempts
        .where((attempt) => now.difference(attempt) < _rateLimitWindow)
        .toList();

    // Update the attempts list
    _creationAttempts[userId] = validAttempts;

    // Check if under the limit
    if (validAttempts.length >= _maxAttemptsPerHour) {
      return false;
    }

    // Add current attempt
    validAttempts.add(now);
    return true;
  }

  // Get remaining attempts for user
  static int getRemainingAttempts(String userId) {
    final now = DateTime.now();
    final userAttempts = _creationAttempts[userId] ?? [];

    final validAttempts = userAttempts
        .where((attempt) => now.difference(attempt) < _rateLimitWindow)
        .toList();

    return _maxAttemptsPerHour - validAttempts.length;
  }

  // Validate group name for security
  static bool isValidGroupName(String name) {
    if (name.isEmpty || name.trim().isEmpty) return false;

    // Check for minimum length
    if (name.trim().length < 3) return false;

    // Check for maximum length
    if (name.length > 50) return false;

    // Check for potentially malicious patterns
    final maliciousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*='),
      RegExp(r'[\x00-\x1f\x7f-\x9f]'), // Control characters
    ];

    for (final pattern in maliciousPatterns) {
      if (pattern.hasMatch(name)) return false;
    }

    return true;
  }

  // Validate group ID format
  static bool isValidGroupID(String groupID) {
    if (groupID.length != 6) return false;
    return RegExp(r'^\d{6}$').hasMatch(groupID);
  }

  // Clean up old rate limit data (call periodically)
  static void cleanupRateLimitData() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    for (final entry in _creationAttempts.entries) {
      final validAttempts = entry.value
          .where((attempt) => now.difference(attempt) < _rateLimitWindow)
          .toList();

      if (validAttempts.isEmpty) {
        keysToRemove.add(entry.key);
      } else {
        entry.value.clear();
        entry.value.addAll(validAttempts);
      }
    }

    for (final key in keysToRemove) {
      _creationAttempts.remove(key);
    }
  }
}