class CityAirData {
  String _cityName;
  int _aqi;
  int _pm25;

  CityAirData({
    required String cityName,
    required int aqi,
    required int pm25,
  })  : _cityName = cityName,
        _aqi = aqi,
        _pm25 = pm25;

  // Getters
  String get cityName => _cityName;
  int get aqi => _aqi;
  int get pm25 => _pm25;

  // Setters
  set cityName(String value) => _cityName = value;
  set aqi(int value) => _aqi = value;
  set pm25(int value) => _pm25 = value;

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
