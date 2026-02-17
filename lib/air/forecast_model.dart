/// Represents a single day's forecast data from the WAQI API.
class ForecastDay {
  final DateTime date;
  final double aqi;

  ForecastDay({required this.date, required this.aqi});
}

/// Forecast data parsed from the WAQI API response.
/// The API returns forecast.daily with pm25, o3, pm10 arrays.
/// We use pm25 avg as the primary AQI for display.
class AirForecast {
  final List<ForecastDay> days;
  /// Name of the pollutant being forecast (e.g. PM2.5, O3, PM10).
  final String pollutantName;

  AirForecast({required this.days, required this.pollutantName});

  bool get isEmpty => days.isEmpty;

  /// Parses forecast from WAQI API data.forecast.daily structure.
  /// Returns null if forecast is not available.
  static AirForecast? fromJson(Map<String, dynamic>? data) {
    if (data == null) return null;
    final forecast = data['forecast'] as Map<String, dynamic>?;
    if (forecast == null) return null;
    final daily = forecast['daily'] as Map<String, dynamic>?;
    if (daily == null) return null;

    // Prefer pm25 for AQI; fallback to o3 or pm10
    List<Map<String, dynamic>>? entries;
    String pollutantName;
    if (daily['pm25'] != null) {
      entries = List<Map<String, dynamic>>.from(daily['pm25']);
      pollutantName = 'PM2.5';
    } else if (daily['o3'] != null) {
      entries = List<Map<String, dynamic>>.from(daily['o3']);
      pollutantName = 'O3';
    } else if (daily['pm10'] != null) {
      entries = List<Map<String, dynamic>>.from(daily['pm10']);
      pollutantName = 'PM10';
    } else {
      return null;
    }
    if (entries == null || entries.isEmpty) return null;

    final days = <ForecastDay>[];
    for (final e in entries) {
      final dayStr = e['day'] as String?;
      if (dayStr == null) continue;
      final avg = (e['avg'] ?? e['max'] ?? e['min']) as num?;
      if (avg == null) continue;
      try {
        final date = DateTime.parse(dayStr);
        days.add(ForecastDay(date: date, aqi: avg.toDouble()));
      } catch (_) {
        // skip invalid dates
      }
    }
    if (days.isEmpty) return null;
    return AirForecast(days: days, pollutantName: pollutantName);
  }
}
