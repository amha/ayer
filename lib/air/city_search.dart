import 'package:flutter/material.dart';
import 'city_view.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ayer/learning/aqi_basics.dart';
import 'package:provider/provider.dart';
import 'package:ayer/main.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Example list of strings - replace with your actual data
  final List<String> items = [
    'New York City',
    'Montreal',
    'Addis Ababa',
    'Athens',
    'Paris',
  ];

  List<String> filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  // void _filterItems(String query) {
  //   setState(() {
  //     filteredItems = items
  //         .where((item) => item.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.air),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AQIBasics()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('About this search'),
                    content: const Text(
                        'Āyer uses the World Air Quality project\'s APIs to provide air quality data.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          _launchURL('https://aqicn.org/faq/');
                          Navigator.of(context).pop();
                        },
                        child: const Text('Learn More'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter city name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              //onChanged: _filterItems,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  final savedCities = context.read<SavedCities>();
                  final existingCity = savedCities.cities
                      .where((city) =>
                          city.searchTerm.toLowerCase() == value.toLowerCase())
                      .toList();

                  if (existingCity.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FeedDetail(cityName: existingCity[0].searchTerm),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedDetail(cityName: value),
                      ),
                    );
                  }
                }
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Suggested searches',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1 / 1.1, // width:height ratio of 1:2
                children: [
                  _buildCityButton('New York City', '🏢'),
                  _buildCityButton('London', '🇬🇧'),
                  _buildCityButton('Addis Ababa', '🇪🇹'),
                  _buildCityButton('Seoul', '🇰🇷'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityButton(String cityName, String emoji) {
    return OutlinedButton(
      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
            side: WidgetStateProperty.all<BorderSide>(
              BorderSide(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: .5,
                strokeAlign: -1.0,
              ),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FeedDetail(
              cityName: cityName,
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  cityName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
