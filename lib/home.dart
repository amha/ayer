import 'package:flutter/material.dart';
import 'air/air_search.dart';
import 'air/feed_detail.dart';

/// HomeScreen is the main landing page of the application
/// It displays either a search prompt or a list of saved cities
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List to store saved cities
  final List<String> savedCities = ['London', 'New York', 'Tokyo'];

  // Widget to display when there are no saved cities
  Widget _buildEmptyState() {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Try searching',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find a city so you can start tracking air quality',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchScreen()),
                  );
                },
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display the list of saved cities
  Widget _buildCityList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: savedCities.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text(savedCities[index]),
            onTap: () {
              // Add navigation to city detail page here
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FeedDetail(cityName: savedCities[index])),
              );
            },
          ),
        );
      },
    );
  }

  // Add this method to handle adding cities
  void addCity(String cityName) {
    if (!savedCities.contains(cityName)) {
      setState(() {
        savedCities.add(cityName);
      });
    }
  }

  // Modify the search navigation to handle the result
  void _navigateToSearch() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );

    if (result != null && result is String) {
      addCity(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _navigateToSearch,
          ),
        ],
      ),
      body: savedCities.isEmpty ? _buildEmptyState() : _buildCityList(),
    );
  }
}
