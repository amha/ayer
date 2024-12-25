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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/wind_turbine_free_vector.jpg'),
          const Padding(padding: EdgeInsets.all(16.0)),
          Text(
            'Track air quality in your city',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Text(
            'To get started, search for your city. ',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SizedBox(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              child: const Text(
                'SEARCH',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
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
      SavedCities().addCity(
          CityAirData(cityName: result, aqi: 0, pm25: 0, pm10: 0, o3: 0));
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
