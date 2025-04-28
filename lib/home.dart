import 'package:ayer/devices/device_list.dart';
import 'package:ayer/main.dart';
import 'package:flutter/material.dart';
import 'air/city_search.dart';
import 'air/city_view.dart';
import 'package:provider/provider.dart';
import 'air/aqi_level_data.dart';
import 'package:ayer/settings/settings_screen.dart';
import 'package:ayer/learning/learning_home.dart';
import 'package:ayer/learning/aqi_basics.dart';
import 'package:lottie/lottie.dart';

/// HomeScreen is the main landing page of the application
/// It displays either a search prompt or a list of saved cities
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildCardList(SavedCities cities) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;
        final crossAxisCount = (constraints.maxWidth / 400).floor();

        if (isLargeScreen) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount >= 2 ? crossAxisCount : 2,
              childAspectRatio: 1.33,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: cities.citiesCount(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedDetail(
                        cityName: cities.cities[index].searchTerm,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 27,
                  shadowColor: Colors.black.withAlpha(115),
                  color: getAQIColor(cities.cities[index].aqi),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  surfaceTintColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                cities.cities[index].cityName.length > 25
                                    ? '${cities.cities[index].cityName.substring(0, 25)}...'
                                    : cities.cities[index].cityName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: Colors.black),
                              ),
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
                        const SizedBox(height: 24),
                        Column(
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
                            const SizedBox(height: 8),
                            Text(
                              cities.cities[index].aqi.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 100,
                                fontWeight: FontWeight.w300,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PM10: ${cities.cities[index].pm10.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.black),
                            ),
                            Text(
                              'O3: ${cities.cities[index].o3.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.black),
                            ),
                            Text(
                              'CO: ${cities.cities[index].co.toString()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cities.citiesCount(),
            itemBuilder: (context, index) {
              double cardWidth = MediaQuery.of(context).size.width - 32;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedDetail(
                          cityName: cities.cities[index].searchTerm,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 27,
                    shadowColor: Colors.black.withAlpha(115),
                    color: getAQIColor(cities.cities[index].aqi),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    surfaceTintColor: Colors.transparent,
                    child: SizedBox(
                      width: cardWidth,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    cities.cities[index].cityName.length > 25
                                        ? '${cities.cities[index].cityName.substring(0, 25)}...'
                                        : cities.cities[index].cityName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.black),
                                  ),
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                            const SizedBox(height: 24),
                            Column(
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
                                const SizedBox(height: 8),
                                Text(
                                  cities.cities[index].aqi.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 100,
                                    fontWeight: FontWeight.w300,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'PM10: ${cities.cities[index].pm10.toString()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.black),
                                ),
                                Text(
                                  'O3: ${cities.cities[index].o3.toString()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.black),
                                ),
                                Text(
                                  'CO: ${cities.cities[index].co.toString()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.black),
                                ),
                              ],
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
      },
    );
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
            child: Lottie.asset('assets/turbine.json'),
          ),
          const Padding(padding: EdgeInsets.all(16.0)),
          Text(
            'Here\'s how to breathe easy and live healthy with Āyer',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.left,
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
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Find your city. Save your city.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w300),
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
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Check the AQI before you go out.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w300),
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
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Learn about air quality.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: Theme.of(context).filledButtonTheme.style,
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

  @override
  Widget build(BuildContext context) {
    final cities = context.watch<SavedCities>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text('Āyer'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: cities.citiesCount() == 0
            ? null
            : [
                IconButton(
                  icon: const Icon(Icons.air),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AQIBasics()),
                    );
                  },
                ),
              ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Āyer',
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.space_dashboard_outlined,
                  color: Theme.of(context).primaryColor),
              title: Text('Dashboard',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.air_outlined,
                  color: Theme.of(context).primaryColor),
              title: Text('AQI Learning',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LearningHome()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.device_thermostat_outlined,
                  color: Theme.of(context).primaryColor),
              title: Text('My Sensors',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeviceList()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined,
                  color: Theme.of(context).primaryColor),
              title: Text('Settings',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: cities.citiesCount() == 0
          ? _buildEmptyState()
          : _buildCardList(cities),
      floatingActionButton: cities.citiesCount() == 0
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              backgroundColor: Theme.of(context).primaryColor,
              child:
                  Icon(Icons.search, color: Theme.of(context).primaryColorDark),
            ),
    );
  }
}
