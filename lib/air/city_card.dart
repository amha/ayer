import 'package:flutter/material.dart';
import 'package:ayer/air/city_model.dart';
import 'package:ayer/air/aqi_level_data.dart';

/// Card widget displaying city air quality data, matching the Figma design.
/// White card with circular AQI gauge, date/time header, and pollutant breakdown.
class CityCard extends StatelessWidget {
  final CityAirData city;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onRemove;

  const CityCard({
    super.key,
    required this.city,
    this.onTap,
    this.onViewDetails,
    this.onRemove,
  });

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, $hour:$minute, local time';
  }

  @override
  Widget build(BuildContext context) {
    final aqiColor = getAQIColor(city.aqi);
    final aqiInt = city.aqi.toInt();
    // AQI scale 0-500; gauge shows progress
    final progress = (aqiInt / 500).clamp(0.0, 1.0);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Theme.of(context).cardColor : Colors.white;
    final textColor = isDark
        ? Theme.of(context).colorScheme.onSurface
        : const Color(0xFF1A1A1A);
    final mutedColor = isDark
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
        : const Color(0xFF757575);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.08),
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: city name, date/time, menu
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.cityName.length > 25
                              ? '${city.cityName.substring(0, 25)}...'
                              : city.cityName,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDateTime(city.time),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: mutedColor,
                                    fontSize: 12,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_horiz,
                      color: textColor,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    onSelected: (value) {
                      switch (value) {
                        case 'details':
                          onViewDetails?.call();
                          break;
                        case 'remove':
                          onRemove?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'details',
                        child: Text('View details'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'remove',
                        child: Text('Remove from list'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Circular AQI gauge
              Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          backgroundColor: aqiColor.withOpacity(0.25),
                          valueColor: AlwaysStoppedAnimation<Color>(aqiColor),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            aqiInt.toString(),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'AQI',
                            style: TextStyle(
                              fontSize: 12,
                              color: mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Pollutant breakdown: PM10, O3, NO2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PollutantChip(
                    label: 'PM10',
                    value: (city.pm10 ?? 0).toStringAsFixed(0),
                    textColor: textColor,
                    mutedColor: mutedColor,
                  ),
                  _PollutantChip(
                    label: 'O3',
                    value: (city.o3 ?? 0).toStringAsFixed(0),
                    textColor: textColor,
                    mutedColor: mutedColor,
                  ),
                  _PollutantChip(
                    label: 'NO2',
                    value: (city.no2 ?? 0).toStringAsFixed(0),
                    textColor: textColor,
                    mutedColor: mutedColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PollutantChip extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final Color mutedColor;

  const _PollutantChip({
    required this.label,
    required this.value,
    required this.textColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: mutedColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
