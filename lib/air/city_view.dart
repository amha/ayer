import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:ayer/main.dart';
import 'package:ayer/navigation/main_shell.dart';
import 'package:ayer/air/city_model.dart';
import 'package:ayer/air/forecast_model.dart';
import 'package:ayer/air/aqi_level_data.dart';

/// FeedDetail is a StatefulWidget that displays detailed air quality information for a specific city
class FeedDetail extends StatefulWidget {
  // City name parameter that will be used to fetch specific city data
  final String cityName;

  // Constructor requiring cityName parameter
  const FeedDetail({
    super.key,
    required this.cityName,
  });

  @override
  State<FeedDetail> createState() => _FeedDetailState();
}

/// _FeedDetailState manages the state and UI for the FeedDetail widget
class _FeedDetailState extends State<FeedDetail> {
  // Stores the fetched feed data from the API
  dynamic _feedData;

  // Loading state indicator
  bool _isLoading = true;

  // Stores any error messages that occur during data fetching
  String? _error;

  late CityAirData cityAirData;

  // Forecast data (optional - not all cities have forecast)
  AirForecast? _forecast;

  @override
  void initState() {
    super.initState();
    // Initialize by fetching data when widget is first created
    _fetchFeedData();
  }

  /// Fetches air quality data from the API for the specified city
  Future<void> _fetchFeedData() async {
    try {
      // Get the base URL and API token from environment variables
      String url = dotenv.env['BASE_URL'] ?? '';
      String token = dotenv.env['API_TOKEN'] ?? '';
      // Construct the full request URL with city name and token
      String requestURL = '$url${widget.cityName}/?token=$token';

      // Make GET request to the API
      final response = await http.get(
        Uri.parse(requestURL),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // If request is successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);

        // Update state with the fetched data and set loading to false
        setState(() {
          _feedData = data;
          _isLoading = false;

          if (_feedData['data'].containsKey('city')) {
            cityAirData =
                CityAirData.fromJson(_feedData['data'], widget.cityName);
            _forecast = AirForecast.fromJson(_feedData['data']);
            _isLoading = false;
          } else {
            _error = 'Error: ${_feedData['message']}';
            _isLoading = false;
            return;
          }
        });
      } else {
        // Handle unsuccessful response by setting error message
        setState(() {
          _error = 'Failed to load data: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  String _formatTimestamp(DateTime dt) {
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
    final hour12 = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'am' : 'pm';
    return '${months[dt.month - 1]} ${dt.day}, $hour12:$minute$period';
  }

  Widget _buildCard1(BuildContext context) {
    final aqi = cityAirData.aqi;
    final aqiColor = getAQIColor(aqi);
    final aqiLabel = getAQILabel(aqi);
    final aqiInt = aqi.toInt();
    final progress = (aqiInt / 500).clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Theme.of(context).cardColor : Colors.white;
    final textColor = isDark
        ? Theme.of(context).colorScheme.onSurface
        : const Color(0xFF1A1A1A);
    final mutedColor = isDark
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
        : const Color(0xFF757575);

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      color: cardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cityAirData.cityName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    aqiLabel,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: aqiColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(cityAirData.time),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: mutedColor,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'AQI',
                        style: TextStyle(
                          fontSize: 11,
                          color: mutedColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard2(BuildContext context) {
    final forecast = _forecast!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Theme.of(context).cardColor : Colors.white;
    final textColor = isDark
        ? Theme.of(context).colorScheme.onSurface
        : const Color(0xFF1A1A1A);
    final mutedColor = isDark
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
        : const Color(0xFF757575);
    const maxAqi = 200.0;

    return Card(
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
          children: [
            Text(
              'FORECAST ${forecast.pollutantName}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: forecast.days.take(7).map((day) {
                  final barHeight = (day.aqi / maxAqi).clamp(0.05, 1.0) * 60.0;
                  final color = getAQIColor(day.aqi);
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
                  final label = '${months[day.date.month - 1]} ${day.date.day}';
                  final aqiValue = day.aqi.toInt();
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            aqiValue.toString(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 10,
                              color: mutedColor,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Implement reminder
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
                child: const Text('Set Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard3(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Theme.of(context).cardColor : Colors.white;
    final textColor = isDark
        ? Theme.of(context).colorScheme.onSurface
        : const Color(0xFF1A1A1A);
    final mutedColor = isDark
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
        : const Color(0xFF757575);

    String formatPollutant(double? value) {
      if (value == null || value == 0) return 'Unavailable';
      return value.toStringAsFixed(0);
    }

    final pollutants = [
      ('PM2.5', formatPollutant(cityAirData.pm25)),
      ('PM10', formatPollutant(cityAirData.pm10)),
      ('CO', formatPollutant(cityAirData.co)),
      ('O3', formatPollutant(cityAirData.o3)),
      ('NO2', formatPollutant(cityAirData.no2)),
    ];

    return Card(
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
          children: [
            Text(
              'POLLUTANTS',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < pollutants.length; i++) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pollutants[i].$1,
                      style: TextStyle(
                        fontSize: 15,
                        color: mutedColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      pollutants[i].$2,
                      style: pollutants[i].$2 == 'Unavailable'
                          ? TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: mutedColor,
                            )
                          : TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                    ),
                  ],
                ),
              ),
              if (i < pollutants.length - 1) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(widget.cityName),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Didn't find ${widget.cityName}",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Maybe the city doesn't exist and you should create it. 🤔",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: const Color.fromARGB(255, 75, 74, 74),
                                ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            "Here are other cities you can search for:",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FeedDetail(
                                    cityName: "New York City",
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "🏢 New York City",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FeedDetail(
                                    cityName: "London",
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "🇬🇧 London",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FeedDetail(
                                    cityName: "Addis Ababa",
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "🇪🇹 Addis Ababa",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FeedDetail(
                                    cityName: "Seoul",
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "🇰🇷 Seoul",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: Theme.of(context).filledButtonTheme.style,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Try searching again",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Card 1: City name, status, timestamp, AQI gauge
                          _buildCard1(context),
                          const SizedBox(height: 16),

                          // Card 2: Forecast (only if available)
                          if (_forecast != null &&
                              _forecast!.days.isNotEmpty) ...[
                            _buildCard2(context),
                            const SizedBox(height: 16),
                          ],

                          // Card 3: Pollutant list
                          _buildCard3(context),
                          const SizedBox(height: 16),

                          // Add/Remove from Dashboard button
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: context
                                      .read<SavedCities>()
                                      .cities
                                      .any((city) =>
                                          city.searchTerm == widget.cityName)
                                  ? const Color.fromARGB(255, 255, 232, 226)
                                  : Theme.of(context).primaryColor,
                              foregroundColor: context
                                      .read<SavedCities>()
                                      .cities
                                      .any((city) =>
                                          city.searchTerm == widget.cityName)
                                  ? Colors.black
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              if (context.read<SavedCities>().cities.any(
                                  (city) =>
                                      city.searchTerm == widget.cityName)) {
                                // Remove city logic
                                context
                                    .read<SavedCities>()
                                    .removeCity(widget.cityName);
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('🗑️ City removed from dashboard'),
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const MainShell(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(-1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                // Add city logic
                                Provider.of<SavedCities>(context, listen: false)
                                    .addCity(cityAirData);
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '✨ ${widget.cityName} added to dashboard'),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const MainShell(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(-1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                            child: context.read<SavedCities>().cities.any(
                                    (city) =>
                                        city.searchTerm == widget.cityName)
                                ? Text('REMOVE FROM DASHBOARD',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                            color: const Color(0xffC32813),
                                            fontWeight: FontWeight.bold))
                                : Text(
                                    'ADD TO DASHBOARD',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                          ),
                        ],
                      ),
                    ),
        ));
  }
}
