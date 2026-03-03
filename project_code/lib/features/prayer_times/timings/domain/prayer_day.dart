class PrayerDay {
  const PrayerDay({
    required this.date,
    required this.timezone,
    required this.method,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  final DateTime date;
  final String timezone;
  final String method;
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  Map<String, Object> toJson() {
    return <String, Object>{
      'date': date.toIso8601String(),
      'timezone': timezone,
      'method': method,
      'fajr': fajr,
      'sunrise': sunrise,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
    };
  }

  static PrayerDay fromJson(Map<String, Object?> json) {
    return PrayerDay(
      date: DateTime.parse('${json['date']}'),
      timezone: '${json['timezone']}',
      method: '${json['method']}',
      fajr: '${json['fajr']}',
      sunrise: '${json['sunrise']}',
      dhuhr: '${json['dhuhr']}',
      asr: '${json['asr']}',
      maghrib: '${json['maghrib']}',
      isha: '${json['isha']}',
    );
  }
}
