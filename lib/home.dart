import 'package:ayer/main.dart';
import 'package:flutter/material.dart';
import 'air/city_search.dart';
import 'air/city_view.dart';
import 'package:provider/provider.dart';
import 'air/aqi_level_data.dart';
import 'package:ayer/learning/aqi_basics.dart';
import 'package:ayer/settings/settings_screen.dart';
import 'package:ayer/learning/learning_home.dart';
import 'package:ayer/legal/privacy.dart';
import 'package:ayer/legal/terms.dart';

/// HomeScreen is the main landing page of the application
/// It displays either a search prompt or a list of saved cities
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum ViewType {
  card, // default view
  table,
  cards, // renamed from chart
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _getSelectedView(SavedCities cities) {
    switch (cities.currentView) {
      case ViewType.table:
        return _buildContentList(cities);
      case ViewType.cards:
        return _buildCardList(cities);
      case ViewType.card:
        return _buildDenseList(context);
    }
  }

  // Widget to display when there are no saved cities
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/wind_turbine_free_vector.jpg',
                  width: 300, height: 300),
            ),
          ),
          const Padding(padding: EdgeInsets.all(16.0)),
          Text(
            'Track air quality in your city',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Learn about Air Quality Basics (AQI)',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Search and save cities you visit',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Review AQI before you go out',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
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
  Widget _buildDenseList(BuildContext context) {
    final SavedCities cities = context.read<SavedCities>();

    return Padding(
      padding: const EdgeInsets.all(0.0),
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
                // City Name
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 16.0,
                    bottom: 16.0,
                    right: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          cities.cities[index].cityName.length > 30
                              ? '${cities.cities[index].cityName.substring(0, 30)}...'
                              : cities.cities[index].cityName,
                          style: Theme.of(context).textTheme.headlineSmall,
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
                ),

                // Chip row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(
                            getAQILabel(cities.cities[index].aqi),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          backgroundColor:
                              getAQIColor(cities.cities[index].aqi),
                          side: BorderSide.none,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(
                            "🕙 ${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricItem(
                          "PM2.5", cities.cities[index].pm25.toString()),
                      _buildMetricItem(
                          "PM10", cities.cities[index].pm10.toString()),
                      _buildMetricItem(
                          "O3", cities.cities[index].o3.toString()),
                      _buildMetricItem(
                          "AQI", cities.cities[index].aqi.toString()),
                    ],
                  ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Add new view builders
  Widget _buildContentList(SavedCities cities) {
    return ListView.builder(
      padding: const EdgeInsets.all(0.0),
      itemCount: cities.citiesCount(),
      itemBuilder: (context, index) {
        final city = cities.cities[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          elevation: 0.5,
          child: ListTile(
            isThreeLine: true,
            tileColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
            leading: CircleAvatar(
              backgroundColor: getAQIColor(city.aqi),
              radius: 10,
            ),
            title: Text(
              city.cityName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            subtitle: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'PM2.5: ${city.pm25}  |  PM10: ${city.pm10}  |  O₃: ${city.o3}',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 135, 134, 134)),
                  ),
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    text: getAQIDescription(city.aqi.toInt()),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: Color.fromARGB(255, 66, 65, 65)),
                  ),
                ],
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'AQI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF757575),
                  ),
                ),
                Text(
                  city.aqi.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedDetail(
                    cityName: city.cityName,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Add this helper function to get the AQI description
  String getAQIDescription(int aqi) {
    final label = getAQILabel(aqi.toDouble());
    switch (label) {
      case "Good":
        return "Air quality is satisfactory, and air pollution poses little or no risk.";
      case "Moderate":
        return "Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution.";
      case "Unhealthy for Sensitive Groups":
        return "ome members of the general public may experience health effects; members of sensitive groups may experience more serious health effects.";
      case "Unhealthy":
        return "Health alert: The risk of health effects is increased for everyone.";
      case "Very Unhealthy":
        return "Health alert: The risk of health effects is increased for everyone.";
      case "Hazardous":
        return "Health warning of emergency conditions: everyone is more likely to be affected.";
      default:
        return "No description available";
    }
  }

  Widget _buildCardList(SavedCities cities) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cities.citiesCount(),
      itemBuilder: (context, index) {
        double cardWidth =
            MediaQuery.of(context).size.width - 32; // Full width minus padding
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Card(
            elevation: 27,
            shadowColor: Colors.black.withAlpha(115),
            color: getAQIColor(cities.cities[index].aqi),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            surfaceTintColor: Colors.transparent,
            child: GestureDetector(
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
              child: SizedBox(
                width: cardWidth,
                height: cardWidth * 0.75,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    children: [
                      // First row (1/5 height)
                      SizedBox(
                        height: (cardWidth * 0.75) * 0.14,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cities.cities[index].cityName.length > 25
                                  ? '${cities.cities[index].cityName.substring(0, 25)}...'
                                  : cities.cities[index].cityName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.black,
                                size: 24,
                              ),
                              onSelected: (value) {
                                switch (value) {
                                  case 'details':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FeedDetail(
                                          cityName:
                                              cities.cities[index].cityName,
                                        ),
                                      ),
                                    );
                                    break;
                                  case 'remove':
                                    context.read<SavedCities>().removeCity(
                                        cities.cities[index].cityName);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('🗑️ City removed'),
                                        duration: Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem<String>(
                                  value: 'details',
                                  child: Text('View details'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'remove',
                                  child: Text('Remove from list'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Second row (3/5 height)
                      SizedBox(
                        height: (cardWidth * 0.75) * 0.65,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'AQI',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  cities.cities[index].aqi.toInt().toString(),
                                  textHeightBehavior: const TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 100,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Third row (1/5 height)
                      SizedBox(
                        height: (cardWidth * 0.75) * 0.14,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'PM10: ${cities.cities[index].pm10.toString()}'),
                            Text('O3: ${cities.cities[index].o3.toString()}'),
                            Text('CO: ${cities.cities[index].co.toString()}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cities = context.watch<SavedCities>();

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text('Ayer',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        actions: cities.citiesCount() == 0
            ? null
            : [
                PopupMenuButton<ViewType>(
                  icon: const Icon(Icons.dashboard),
                  onSelected: (ViewType result) {
                    context.read<SavedCities>().setCurrentView(result);
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<ViewType>(
                      value: ViewType.card,
                      child: Row(
                        children: [
                          Icon(Icons.view_agenda),
                          SizedBox(width: 8),
                          Text('Default'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<ViewType>(
                      value: ViewType.table,
                      child: Row(
                        children: [
                          Icon(Icons.list),
                          SizedBox(width: 8),
                          Text('List'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<ViewType>(
                      value: ViewType.cards,
                      child: Row(
                        children: [
                          Icon(Icons.dashboard),
                          SizedBox(width: 8),
                          Text('Cards'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Ayer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.air),
              title: const Text('AQI Learning'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LearningHome()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacyPolicy()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Terms of Use'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsOfUse()),
                );
              },
            ),
          ],
        ),
      ),
      body: cities.citiesCount() == 0
          ? _buildEmptyState()
          : _getSelectedView(cities),
      floatingActionButton: cities.citiesCount() == 0
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              backgroundColor: Colors.black,
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}
