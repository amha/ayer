import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:ayer/main.dart';
import 'package:ayer/home.dart';
import 'package:ayer/air/city_model.dart';
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
            cityAirData = CityAirData.fromJson(_feedData['data']);
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

  void _showInfoDialog(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // First Child - AQI Display
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(0, 12.0, 0.0, 12.0),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'AIR QUALITY INDEX',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        Text(
                                          cityAirData.time
                                              .toLocal()
                                              .toString()
                                              .split('.')[0],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.grey),
                                        ),
                                        Chip(
                                            label: Text(
                                              getAQILabel(double.parse(
                                                  cityAirData.pm25.toString())),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                                fontSize: 16,
                                              ),
                                            ),
                                            backgroundColor: getAQIColor(
                                                double.parse(cityAirData.pm25
                                                    .toString())),
                                            side: BorderSide.none),
                                        Text(
                                          _feedData['data']['aqi'].toString(),
                                          style: const TextStyle(
                                              fontSize: 90,
                                              fontWeight: FontWeight.w200),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        const Text(
                                            'Its a great day to be active outside.',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300)),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Second Child - Metrics List
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: .5,
                                ),
                                ListTile(
                                  title: TextButton.icon(
                                    onPressed: () {
                                      _showInfoDialog(
                                        context,
                                        'City Name',
                                        'The name of the city where air quality is being measured.',
                                      );
                                    },
                                    label: Text(
                                      'CITY',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: const Color(0xFF757575),
                                            fontSize: 15,
                                          ),
                                    ),
                                    icon: const Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: Color(0xFF757575),
                                    ),
                                    iconAlignment: IconAlignment.end,
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  trailing: Text(
                                    cityAirData.cityName.length > 12
                                        ? '${cityAirData.cityName.substring(0, 12)}...'
                                        : cityAirData.cityName,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: .5,
                                ),
                                ListTile(
                                  title: TextButton.icon(
                                    onPressed: () {
                                      _showInfoDialog(
                                        context,
                                        'PM2.5',
                                        'Fine particulate matter with diameter less than 2.5 micrometers. These particles can penetrate deep into your lungs.',
                                      );
                                    },
                                    label: Text(
                                      'PM2.5',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: const Color(0xFF757575),
                                            fontSize: 15,
                                          ),
                                    ),
                                    icon: const Icon(Icons.info_outline,
                                        size: 16, color: Color(0xFF757575)),
                                    iconAlignment: IconAlignment.end,
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  trailing: Text(
                                    cityAirData.pm25.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: .5,
                                ),
                                ListTile(
                                  title: TextButton.icon(
                                    onPressed: () {
                                      _showInfoDialog(
                                        context,
                                        'PM10',
                                        'Coarse particulate matter with diameter less than 10 micrometers. These particles can enter your respiratory system.',
                                      );
                                    },
                                    label: Text('PM10',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: const Color(0xFF757575),
                                              fontSize: 15,
                                            )),
                                    icon: const Icon(Icons.info_outline,
                                        size: 16, color: Color(0xFF757575)),
                                    iconAlignment: IconAlignment.end,
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  trailing: Text(
                                    cityAirData.pm10.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: .5,
                                ),
                                ListTile(
                                  title: TextButton.icon(
                                    onPressed: () {
                                      _showInfoDialog(
                                        context,
                                        'Carbon Monoxide',
                                        'A colorless, odorless gas that can be harmful when inhaled in large amounts. CO is released when something is burned.',
                                      );
                                    },
                                    label: Text('CO',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: const Color(0xFF757575),
                                              fontSize: 15,
                                            )),
                                    icon: const Icon(Icons.info_outline,
                                        size: 16, color: Color(0xFF757575)),
                                    iconAlignment: IconAlignment.end,
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  trailing: Text(
                                    cityAirData.co.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: .5,
                                ),
                                ListTile(
                                  title: TextButton.icon(
                                    onPressed: () {
                                      _showInfoDialog(
                                        context,
                                        'Ozone',
                                        'Ground-level ozone is a major component of smog. It forms when pollutants react in sunlight and can cause respiratory problems.',
                                      );
                                    },
                                    label: Text('O3',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: const Color(0xFF757575),
                                              fontSize: 15,
                                            )),
                                    icon: const Icon(Icons.info_outline,
                                        size: 16, color: Color(0xFF757575)),
                                    iconAlignment: IconAlignment.end,
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  trailing: Text(
                                    cityAirData.o3.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: .5,
                                ),
                                ListTile(
                                  title: TextButton.icon(
                                    onPressed: () {
                                      _showInfoDialog(
                                        context,
                                        'Nitrogen Dioxide',
                                        'A reddish-brown gas that primarily comes from burning fuel. It can cause respiratory issues and contribute to the formation of other pollutants.',
                                      );
                                    },
                                    label: Text('NO2',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: const Color(0xFF757575),
                                              fontSize: 15,
                                            )),
                                    icon: const Icon(Icons.info_outline,
                                        size: 16, color: Color(0xFF757575)),
                                    iconAlignment: IconAlignment.end,
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  trailing: Text(
                                    cityAirData.no2.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Third Child - Button
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            width: MediaQuery.of(context).size.width,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: context
                                        .read<SavedCities>()
                                        .cities
                                        .any((city) =>
                                            city.cityName == widget.cityName)
                                    ? const Color(0xffffc7b8)
                                    : Colors.black,
                                foregroundColor: context
                                        .read<SavedCities>()
                                        .cities
                                        .any((city) =>
                                            city.cityName == widget.cityName)
                                    ? Colors.black
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () {
                                if (context.read<SavedCities>().cities.any(
                                    (city) =>
                                        city.cityName == widget.cityName)) {
                                  // Remove city logic
                                  context
                                      .read<SavedCities>()
                                      .removeCity(widget.cityName);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          '🗑️ City removed from dashboard'),
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const HomeScreen(),
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
                                  Provider.of<SavedCities>(context,
                                          listen: false)
                                      .addCity(cityAirData);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('✨ City added to dashboard'),
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const HomeScreen(),
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
                                          city.cityName == widget.cityName)
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
                          ),
                        ],
                      ),
                    ),
        ));
  }
}
