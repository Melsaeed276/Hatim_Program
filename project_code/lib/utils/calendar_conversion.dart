import 'package:hijri/hijri_calendar.dart';

/// Utility class for Hijri <-> Gregorian calendar conversions
/// Used throughout the app to handle dual calendar display and storage
class CalendarConversion {
  /// Convert Hijri date + time to Gregorian DateTime
  /// Returns a DateTime representing the same moment in Gregorian calendar
  static DateTime hijriToGregorian({
    required int hijriYear,
    required int hijriMonth,
    required int hijriDay,
    int hour = 0,
    int minute = 0,
  }) {
    final hijriDate = HijriCalendar()
      ..hYear = hijriYear
      ..hMonth = hijriMonth
      ..hDay = hijriDay;
    
    final gregorianDate = hijriDate.hijriToGregorian(hijriYear, hijriMonth, hijriDay);
    
    return DateTime(
      gregorianDate.year,
      gregorianDate.month,
      gregorianDate.day,
      hour,
      minute,
    );
  }

  /// Convert Gregorian DateTime to Hijri date components
  /// Returns a HijriDate record with year, month, day
  static HijriDate gregorianToHijri(DateTime gregorianDate) {
    final hijri = HijriCalendar.fromDate(gregorianDate);
    return HijriDate(
      year: hijri.hYear,
      month: hijri.hMonth,
      day: hijri.hDay,
    );
  }

  /// Get current Hijri date
  static HijriDate getCurrentHijriDate() {
    final now = HijriCalendar.now();
    return HijriDate(
      year: now.hYear,
      month: now.hMonth,
      day: now.hDay,
    );
  }

  /// Format Hijri date as string (e.g., "15 Ramadan 1446")
  static String formatHijriDate({
    required int year,
    required int month,
    required int day,
    bool includeWeekday = false,
  }) {
    final hijri = HijriCalendar()
      ..hYear = year
      ..hMonth = month
      ..hDay = day;
    
    final monthName = _getHijriMonthName(month);
    
    if (includeWeekday) {
      // Get the Gregorian date to determine weekday
      final gregorian = hijri.hijriToGregorian(year, month, day);
      final weekday = _getWeekdayName(gregorian.weekday);
      return '$weekday, $day $monthName $year';
    }
    
    return '$day $monthName $year';
  }

  /// Format Gregorian date as string (e.g., "December 31, 2025")
  static String formatGregorianDate(DateTime date, {bool includeWeekday = false}) {
    final monthName = _getGregorianMonthName(date.month);
    
    if (includeWeekday) {
      final weekday = _getWeekdayName(date.weekday);
      return '$weekday, $monthName ${date.day}, ${date.year}';
    }
    
    return '$monthName ${date.day}, ${date.year}';
  }

  /// Format time as string (e.g., "14:30" or "2:30 PM")
  static String formatTime(int hour, int minute, {bool use24Hour = true}) {
    if (use24Hour) {
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else {
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    }
  }

  /// Get both Hijri and Gregorian formatted strings for a given DateTime
  static DualDateDisplay getDualDateDisplay(DateTime gregorianDate) {
    final hijri = gregorianToHijri(gregorianDate);
    
    return DualDateDisplay(
      gregorian: formatGregorianDate(gregorianDate),
      hijri: formatHijriDate(year: hijri.year, month: hijri.month, day: hijri.day),
    );
  }

  /// Validate Hijri date components
  static bool isValidHijriDate(int year, int month, int day) {
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 30) return false;
    if (year < 1) return false;
    
    // Hijri months alternate between 29 and 30 days
    // Months 1,3,5,7,9,11 have 30 days; 2,4,6,8,10,12 have 29 days (usually)
    // Month 12 can have 30 days in leap years
    final maxDays = _getHijriMonthDays(year, month);
    return day <= maxDays;
  }

  /// Get number of days in a Hijri month
  static int _getHijriMonthDays(int year, int month) {
    // Odd months (1,3,5,7,9,11) have 30 days
    // Even months (2,4,6,8,10) have 29 days
    // Month 12 has 29 days in normal years, 30 in leap years
    if (month == 12) {
      return _isHijriLeapYear(year) ? 30 : 29;
    }
    return month.isOdd ? 30 : 29;
  }

  /// Check if a Hijri year is a leap year
  static bool _isHijriLeapYear(int year) {
    // Hijri leap years occur in years 2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29
    // of each 30-year cycle
    final positionInCycle = year % 30;
    return [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29].contains(positionInCycle);
  }

  static String _getHijriMonthName(int month) {
    const months = [
      'Muharram',
      'Safar',
      'Rabi\' al-Awwal',
      'Rabi\' al-Thani',
      'Jumada al-Awwal',
      'Jumada al-Thani',
      'Rajab',
      'Sha\'ban',
      'Ramadan',
      'Shawwal',
      'Dhu al-Qi\'dah',
      'Dhu al-Hijjah',
    ];
    return months[month - 1];
  }

  static String _getGregorianMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  static String _getWeekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[weekday - 1];
  }

  /// Get list of Hijri month names for dropdowns
  static List<String> getHijriMonthNames() {
    return [
      'Muharram',
      'Safar',
      'Rabi\' al-Awwal',
      'Rabi\' al-Thani',
      'Jumada al-Awwal',
      'Jumada al-Thani',
      'Rajab',
      'Sha\'ban',
      'Ramadan',
      'Shawwal',
      'Dhu al-Qi\'dah',
      'Dhu al-Hijjah',
    ];
  }

  /// Get list of Gregorian month names for dropdowns
  static List<String> getGregorianMonthNames() {
    return [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
  }
}

/// Record class to hold Hijri date components
class HijriDate {
  final int year;
  final int month;
  final int day;

  const HijriDate({
    required this.year,
    required this.month,
    required this.day,
  });

  @override
  String toString() => '$day/$month/$year (Hijri)';
}

/// Record class to hold dual date display strings
class DualDateDisplay {
  final String gregorian;
  final String hijri;

  const DualDateDisplay({
    required this.gregorian,
    required this.hijri,
  });
}
