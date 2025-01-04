import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:ayer/main.dart';
import 'package:ayer/home.dart';
import 'package:ayer/air/city_air_data.dart';
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

  // Store api data for specific measuerments
  String? pm10Value;
  String? pm25Value;
  String? o3Value;
  String? coValue;
  String? no2Value;
  String? cityNameValue;

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

          if (_feedData['status'] == 'error') {
            _error = 'Error: ${_feedData['message']}';
            _isLoading = false;
            return;
          }

          // Always available from AQI data
          cityNameValue = _feedData['data']['city']['name'].toString();
          pm25Value = _feedData['data']['iaqi']['pm25']['v'].toString();

          // Sometimes available from AQI data
          pm10Value =
              _feedData['data']['iaqi']?['pm10']?['v']?.toString() ?? "0";
          o3Value = _feedData['data']['iaqi']?['o3']?['v']?.toString() ?? "0";
          coValue = _feedData['data']['iaqi']?['co']?['v']?.toString() ?? "0";
          no2Value = _feedData['data']['iaqi']?['no2']?['v']?.toString() ?? "0";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.cityName),
          backgroundColor: Colors.white,
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
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Maybe the city doesn't exist and you should create it. 🤔",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            "Here are other cities you can search for:",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Try searching again",
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                                        const Text(
                                          'AIR QUALITY INDEX',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        const Text(
                                          'May 8, 2024',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16),
                                        ),
                                        Chip(
                                            label: Text(
                                              getAQILabel(
                                                  int.parse(pm25Value ?? "0")),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: getAQIColor(int.parse(
                                                    pm25Value ?? "0")),
                                                fontSize: 16,
                                              ),
                                            ),
                                            backgroundColor: getAQIColor(
                                                    int.parse(pm25Value ?? "0"))
                                                .withOpacity(.1),
                                            side: BorderSide.none),
                                        Text(
                                          _feedData['data']['aqi'].toString(),
                                          style: const TextStyle(
                                              fontSize: 68,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        const Text(
                                            'Its a great day to be active outside.',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300)),
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        const Text('What does this score mean?',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline)),
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
                                  title: Text('CITY NAME',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  trailing: Text(cityNameValue ?? "Nothing"),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: .5,
                                ),
                                ListTile(
                                  title: Text('PM2.5',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  trailing: Text(pm25Value ?? "null"),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: .5,
                                ),
                                ListTile(
                                  title: Text('PM10',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  trailing: Text(pm10Value ?? "null"),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: .5,
                                ),
                                ListTile(
                                  title: Text('CO',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  trailing: Text(coValue ?? "N/A"),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  thickness: .5,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Third Child - Button
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context
                                        .read<SavedCities>()
                                        .cities
                                        .any((city) =>
                                            city.cityName == widget.cityName)
                                    ? Colors.white
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
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
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
                                  // Add city logic (existing code)
                                  Provider.of<SavedCities>(context,
                                          listen: false)
                                      .addCity(CityAirData(
                                          cityName: _feedData['data']['city']
                                              ['name'],
                                          aqi: double.parse(_feedData['data']
                                                  ['aqi']
                                              .toString()),
                                          pm25: double.parse(pm25Value ?? "0"),
                                          pm10: double.parse(pm10Value ?? "0"),
                                          o3: double.parse(o3Value ?? "0")));
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
                              child: Text(
                                context.read<SavedCities>().cities.any((city) =>
                                        city.cityName == widget.cityName)
                                    ? 'REMOVE FROM DASHBOARD'
                                    : 'ADD TO DASHBOARD',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ));
  }
}
