import 'package:flutter/material.dart';

class AQILevel {
  final int min;
  final int max;
  final String label;
  final Color color;

  AQILevel({
    required this.min,
    required this.max,
    required this.label,
    required this.color,
  });

  // Check if a value is within this range
  bool contains(int value) => value >= min && value <= max;
}

// Define the AQI levels
final List<AQILevel> aqiLevels = [
  AQILevel(min: 0, max: 50, label: "Good", color: const Color(0xFFa3e048)),
  AQILevel(
      min: 51, max: 100, label: "Moderate", color: const Color(0xFFf7d038)),
  AQILevel(
      min: 101,
      max: 150,
      label: "Unhealthy for Sensitive Groups",
      color: const Color(0xFFeb7532)),
  AQILevel(
      min: 151, max: 200, label: "Unhealthy", color: const Color(0xFFfe6261)),
  AQILevel(
      min: 201,
      max: 300,
      label: "Very Unhealthy",
      color: const Color(0xFFd23be7)),
  AQILevel(min: 301, max: 500, label: "Hazardous", color: Colors.brown),
];

String getAQILabel(double aqi) {
  for (var level in aqiLevels) {
    if (level.contains(aqi.toInt())) {
      return level.label;
    }
  }
  return "Unknown"; // Fallback for invalid AQI values
}

Color getAQIColor(double aqi) {
  for (var level in aqiLevels) {
    if (level.contains(aqi.toInt())) {
      return level.color;
    }
  }
  return Colors.grey; // Fallback for invalid AQI values
}
