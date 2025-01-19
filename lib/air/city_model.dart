class CityAirData {
  String cityName;
  double aqi;
  double pm25;
  double? pm10;
  double? o3;
  double? co;
  double? no2;
  DateTime time;

  CityAirData({
    required this.cityName,
    required this.aqi,
    required this.pm25,
    this.pm10,
    this.o3,
    this.co,
    this.no2,
    DateTime? time,
  }) : time = time ?? DateTime.now();

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
      cityName: json['city']['name'],
      aqi: json['aqi'].toDouble(),
      pm25: json['iaqi']['pm25']['v'].toDouble(),
      pm10: json['iaqi']?['pm10']?['v']?.toDouble() ?? 0.0,
      o3: json['iaqi']?['o3']?['v']?.toDouble() ?? 0.0,
      co: json['iaqi']?['co']?['v']?.toDouble() ?? 0.0,
      no2: json['iaqi']?['no2']?['v']?.toDouble() ?? 0.0,
      time: json['time']['s'] != null
          ? DateTime.parse(json['time']['s'])
          : DateTime.now(),
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
      'time': time.toIso8601String(),
    };
  }
}
