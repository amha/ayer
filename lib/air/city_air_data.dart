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

  /// Creates a CityAirData instance from a JSON map
  factory CityAirData.fromJson(Map<String, dynamic> json) {
    return CityAirData(
      cityName: json['cityName'],
      aqi: json['aqi'],
      pm25: json['pm25'],
      pm10: json['pm10'],
      o3: json['o3'],
    );
  }

  /// Converts the CityAirData instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'aqi': aqi,
      'pm25': pm25,
      'pm10': pm10,
      'o3': o3,
    };
  }
}
