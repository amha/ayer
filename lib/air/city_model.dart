class CityAirData {
  String cityName;
  double aqi;
  double pm25;
  double? pm10;
  double? o3;
  double? co;
  double? no2;

  CityAirData({
    required this.cityName,
    required this.aqi,
    required this.pm25,
    this.pm10,
    this.o3,
    this.co,
    this.no2,
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
    dynamic dynamicAqi = json['aqi'];
    dynamic dynamicPm25 = json['iaqi']['pm25']['v'];
    dynamic dynamicPm10 = json['iaqi']?['pm10']?['v'] ?? 0.0;
    dynamic dynamicO3 = json['iaqi']?['o3']?['v'] ?? 0.0;
    dynamic dynamicCo = json['iaqi']?['co']?['v'] ?? 0.0;
    dynamic dynamicNo2 = json['iaqi']?['no2']?['v'] ?? 0.0;
    return CityAirData(
      cityName: json['city']['name'],
      aqi: dynamicAqi.toDouble(), // Ensure aqi is a string
      pm25: dynamicPm25.toDouble(),
      pm10: dynamicPm10.toDouble(),
      o3: dynamicO3.toDouble(),
      co: dynamicCo.toDouble(),
      no2: dynamicNo2.toDouble(),
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
      'co': co,
      'no2': no2,
    };
  }
}
