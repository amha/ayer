class CityAirData {
  String _cityName;
  double _aqi;
  double _pm25;
  double _pm10;
  double _o3;

  CityAirData({
    required String cityName,
    required double aqi,
    required double pm25,
    required double pm10,
    required double o3,
  })  : _cityName = cityName,
        _aqi = aqi,
        _pm25 = pm25,
        _pm10 = pm10,
        _o3 = o3;

  // Getters
  String get cityName => _cityName;
  double get aqi => _aqi;
  double get pm25 => _pm25;
  double get pm10 => _pm10;
  double get o3 => _o3;
  // Setters
  set cityName(String value) => _cityName = value;
  set aqi(double value) => _aqi = value;
  set pm25(double value) => _pm25 = value;
  set pm10(double value) => _pm10 = value;
  set o3(double value) => _o3 = value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityAirData &&
          _cityName == other._cityName &&
          _aqi == other._aqi &&
          _pm25 == other._pm25;

  @override
  int get hashCode => Object.hash(_cityName, _aqi, _pm25, _pm10, _o3);
}
