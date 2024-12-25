import 'package:ayer/main.dart';
import 'package:flutter/material.dart';
import 'air/air_search.dart';
import 'air/feed_detail.dart';
import 'package:provider/provider.dart';
import 'air/city_air_data.dart';
import 'legal/terms.dart';
import 'legal/privacy.dart';

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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cities.citiesCount(),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedDetail(
                    cityName: cities.cities[index].cityName,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        cities.cities[index].cityName.length > 20
                            ? '${cities.cities[index].cityName.substring(0, 20)}...'
                            : cities.cities[index].cityName,
                        style: Theme.of(context).textTheme.headlineLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Current air quality conditions in your city",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetricItem(
                        "PM2.5", cities.cities[index].pm25.toString()),
                    _buildMetricItem(
                        "PM10", cities.cities[index].pm10.toString()),
                    _buildMetricItem("O3", cities.cities[index].o3.toString()),
                    _buildMetricItem(
                        "AQI", cities.cities[index].aqi.toString()),
                  ],
                ),
                const SizedBox(height: 36),
                const Divider(
                  height: 1,
                  color: Colors.grey,
                  thickness: 0.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              // TODO: Implement chart view
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item selection
              switch (value) {
                case 'settings':
                  // TODO: Navigate to settings
                  break;
                case 'about':
                  // TODO: Navigate to about
                  break;
                case 'terms':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsOfUse()),
                  );
                  break;
                case 'privacy':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicy()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'about',
                child: Text('About'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'terms',
                child: Text('Terms of Use'),
              ),
              const PopupMenuItem<String>(
                value: 'privacy',
                child: Text('Privacy Policy'),
              ),
            ],
          ),
        ],
      ),
      body: cities.citiesCount() == 0
          ? _buildEmptyState()
          : _buildCityList(context),
      floatingActionButton: cities.citiesCount() == 0
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
    );
  }
}
