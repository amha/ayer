import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:ayer/main.dart';
import 'package:ayer/home.dart';
import 'package:ayer/air/city_air_data.dart';

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
        title: const Text('Demo Data'),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: const Offset(0, -1),
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: 0,
                                color: Colors.white,
                                margin: EdgeInsets.zero,
                                child: ListTile(
                                  title: const Text(
                                    'Status',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Text(
                                      style: const TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w300),
                                      _feedData['status'] ?? 'N/A'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: const Offset(0, -1),
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: 0,
                                color: Colors.white,
                                margin: EdgeInsets.zero,
                                child: ListTile(
                                  title: const Text(
                                    'AQI',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Text(
                                      style: const TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w300),
                                      (_feedData['data']['aqi'] ?? 'N/A')
                                          .toString()),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: const Offset(0, -1),
                                  ),
                                ],
                              ),
                              child: Card(
                                elevation: 0,
                                color: Colors.white,
                                margin: EdgeInsets.zero,
                                child: ListTile(
                                  title: const Text(
                                    'City Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Text(
                                      style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w300),
                                      _feedData['data']['city']['name'] ??
                                          'N/A'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            if (context.read<SavedCities>().cities.any(
                                (city) => city.cityName == widget.cityName)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'This city already exists in the list'),
                                ),
                              );
                            } else {
                              Provider.of<SavedCities>(context, listen: false)
                                  .addCity(CityAirData(
                                      cityName: _feedData['data']['city']
                                          ['name'],
                                      aqi: _feedData['data']['aqi'],
                                      pm25: _feedData['data']['iaqi']['pm25']
                                          ['v']));
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
                          child: const Text('Save City'),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
