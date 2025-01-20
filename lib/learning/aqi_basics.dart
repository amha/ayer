import 'package:flutter/material.dart';
import 'package:ayer/air/aqi_level_data.dart';

/// AQIBasics is a StatelessWidget that displays detailed information about
/// different Air Quality Index (AQI) levels and their health implications
class AQIBasics extends StatefulWidget {
  const AQIBasics({super.key});

  @override
  State<AQIBasics> createState() => _AQIBasicsState();
}

class _AQIBasicsState extends State<AQIBasics> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('AQI Information'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is the Air Quality Index (AQI)?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'AQI is a measurement of air quality that indicates how clean or polluted the air is. The level of pollution is displayed as a score that ranges from 0-500.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stepper(
              connectorColor: WidgetStateProperty.all(Colors.black),
              currentStep: _currentStep,
              onStepTapped: (step) {
                setState(() {
                  _currentStep = step;
                });
              },
              controlsBuilder: (context, details) {
                return const SizedBox.shrink(); // Hide default controls
              },
              steps: aqiLevels.map((level) {
                return Step(
                  isActive: aqiLevels.indexOf(level) <= _currentStep,
                  title: Chip(
                    label: Text(
                      level.label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: aqiLevels.indexOf(level) == aqiLevels.length - 1
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    backgroundColor: level.color,
                    side: BorderSide.none,
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AQI Score: ${level.min} - ${level.max}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _getDescription(level.label),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
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
