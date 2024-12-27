class CityAirData {
  String cityName;
  double aqi;
  double pm25;
  double pm10;
  double o3;

  CityAirData({
    required this.cityName,
    required this.aqi,
    required this.pm25,
    required this.pm10,
    required this.o3,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityAirData &&
          cityName == other.cityName &&
          aqi == other.aqi &&
          pm25 == other.pm25;

  @override
  int get hashCode => Object.hash(cityName, aqi, pm25, pm10, o3);
}
