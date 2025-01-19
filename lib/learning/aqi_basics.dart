import 'package:flutter/material.dart';
import 'package:ayer/air/aqi_level_data.dart';

/// AQIBasics is a StatelessWidget that displays detailed information about
/// different Air Quality Index (AQI) levels and their health implications
class AQIBasics extends StatelessWidget {
  const AQIBasics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AQI Information'),
        backgroundColor: Colors.white,
      ),

      /// Creates a scrollable list of AQI levels using ListView.builder
      /// Each item represents a different AQI level with its description
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: aqiLevels.length,
        itemBuilder: (context, index) {
          final level = aqiLevels[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Displays the AQI level label (e.g., "Good", "Moderate")
                /// in a container with a colored border and background
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: level.color.withAlpha(25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: level.color,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    level.label,
                    style: TextStyle(
                      color: level.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// Displays the AQI range for this level
                Text(
                  'Air Quality Index (AQI): ${level.min} - ${level.max}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),

                /// Displays the health implications and description for this AQI level
                Text(
                  _getDescription(level.label),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(height: 1),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Returns a detailed description of health implications for each AQI level
  ///
  /// [label] is the AQI level label (e.g., "Good", "Moderate")
  /// Returns a String containing health implications and recommendations
  String _getDescription(String label) {
    switch (label) {
      case "Good":
        return "Air quality is satisfactory, and air pollution poses little or no risk.";
      case "Moderate":
        return "Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution.";
      case "Unhealthy for Sensitive Groups":
        return "Members of sensitive groups may experience health effects. The general public is less likely to be affected.";
      case "Unhealthy":
        return "Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects.";
      case "Very Unhealthy":
        return "Health alert: The risk of health effects is increased for everyone.";
      case "Hazardous":
        return "Health warning of emergency conditions: everyone is more likely to be affected.";
      default:
        return "No description available.";
    }
  }
}
