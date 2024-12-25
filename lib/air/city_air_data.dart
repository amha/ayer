class CityAirData {
  String _cityName;
  int _aqi;
  int _pm25;
  int _pm10;
  int _o3;

  CityAirData({
    required String cityName,
    required int aqi,
    required int pm25,
    required int pm10,
    required int o3,
  })  : _cityName = cityName,
        _aqi = aqi,
        _pm25 = pm25,
        _pm10 = pm10,
        _o3 = o3;

  // Getters
  String get cityName => _cityName;
  int get aqi => _aqi;
  int get pm25 => _pm25;
  int get pm10 => _pm10;
  int get o3 => _o3;
  // Setters
  set cityName(String value) => _cityName = value;
  set aqi(int value) => _aqi = value;
  set pm25(int value) => _pm25 = value;
  set pm10(int value) => _pm10 = value;
  set o3(int value) => _o3 = value;

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
