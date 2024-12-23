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
          title: Text(widget.cityName),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text(_error!))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // First Child
                        Container(
                            padding:
                                const EdgeInsets.fromLTRB(0, 12.0, 0.0, 12.0),
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      const Chip(
                                          label: Text(
                                            'Good',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1B5E20),
                                              fontSize: 16,
                                            ),
                                          ),
                                          backgroundColor: Color(0xFFCFF7D3),
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
                            ])),

                        // Second Child
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 300,
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
                                    trailing: const Text('data'),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    height: 1,
                                    indent: 16,
                                    endIndent: 16,
                                    thickness: .5,
                                  ),
                                  ListTile(
                                    title: Text('AVG. OZONE (O3)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    trailing: const Text('data'),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    height: 1,
                                    indent: 16,
                                    endIndent: 16,
                                    thickness: .5,
                                  ),
                                  ListTile(
                                    title: Text('PARTICULATE MATTER 2.5',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    trailing: const Text('data'),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    height: 1,
                                    indent: 16,
                                    endIndent: 16,
                                    thickness: .5,
                                  ),
                                  ListTile(
                                    title: Text('PARTICULATE MATTER 10.0',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    trailing: const Text('data'),
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
                            )
                          ],
                        ),

                        // Third Child
                        Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () {
                                  if (context.read<SavedCities>().cities.any(
                                      (city) =>
                                          city.cityName == widget.cityName)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'This city already exists in the list'),
                                      ),
                                    );
                                  } else {
                                    Provider.of<SavedCities>(context,
                                            listen: false)
                                        .addCity(CityAirData(
                                            cityName: _feedData['data']['city']
                                                ['name'],
                                            aqi: _feedData['data']['aqi'],
                                            pm25: _feedData['data']['iaqi']
                                                ['pm25']['v']));
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
                                child: const Text('ADD TO DASHBOARD',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                              ),
                            )),
                      ],
                    ),
        ));
  }
}
