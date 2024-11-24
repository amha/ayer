class CityAirData {
  String _cityName;
  double _aqi;
  double _pm25;

  CityAirData({
    required String cityName,
    required double aqi,
    required double pm25,
  })  : _cityName = cityName,
        _aqi = aqi,
        _pm25 = pm25;

  // Getters
  String get cityName => _cityName;
  double get aqi => _aqi;
  double get pm25 => _pm25;

  // Setters
  set cityName(String value) => _cityName = value;
  set aqi(double value) => _aqi = value;
  set pm25(double value) => _pm25 = value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityAirData &&
          _cityName == other._cityName &&
          _aqi == other._aqi &&
          _pm25 == other._pm25;

  @override
  int get hashCode => Object.hash(_cityName, _aqi, _pm25);
}
