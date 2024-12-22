import 'package:ayer/main.dart';
import 'package:flutter/material.dart';
import 'air/air_search.dart';
import 'air/feed_detail.dart';
import 'package:provider/provider.dart';
import 'air/city_air_data.dart';

/// HomeScreen is the main landing page of the application
/// It displays either a search prompt or a list of saved cities
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              Consumer<SavedCities>(builder: (context, savedCities, child) {
                return Text('Cities: ${savedCities.citiesCount()}');
              })
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display the list of saved cities
  Widget _buildCityList(BuildContext context) {
    final SavedCities cities = context.read<SavedCities>();

    return SizedBox(
      height: MediaQuery.of(context).size.height - 500,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Current Air Quality',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(
              thickness: .5,
              color: Colors.grey,
              indent: 16,
              endIndent: 16,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: cities.citiesCount(),
                itemBuilder: (context, index) {
                  return Container(
                    height: 65,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 0.3,
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        cities.cities[index].cityName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      trailing: Text(cities.cities[index].aqi.toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedDetail(
                                cityName: cities.cities[index].cityName),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modify the search navigation to handle the result
  void _navigateToSearch() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );

    if (result != null && result is String) {
      SavedCities().addCity(CityAirData(cityName: result, aqi: 0, pm25: 0));
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cities = context.watch<SavedCities>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayer'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _navigateToSearch,
          ),
        ],
      ),
      body: cities.citiesCount() == 0
          ? _buildEmptyState()
          : _buildCityList(context),
    );
  }
}
