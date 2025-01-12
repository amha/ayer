import 'package:ayer/air/aqi_basics.dart';
import 'package:ayer/main.dart';
import 'package:flutter/material.dart';
import 'air/air_search.dart';
import 'air/feed_detail.dart';
import 'package:provider/provider.dart';
import 'legal/terms.dart';
import 'legal/privacy.dart';
import 'air/aqi_level_data.dart';

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
  chart,
  story,
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _getSelectedView(SavedCities cities) {
    switch (cities.currentView) {
      case ViewType.table:
        return _buildTableView(cities);
      case ViewType.chart:
        return _buildChartView(cities);
      case ViewType.story:
        return _buildStoryView(cities);
      case ViewType.card:
        return _buildCityList(context);
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
              child: Image.asset('assets/wind_turbine_free_vector.jpg'),
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
                      color: Colors.blue,
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
                      color: Colors.blue,
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
                      color: Colors.blue,
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
                Chip(
                  label: Text(
                    "Conditions are ${getAQILabel(cities.cities[index].aqi)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getAQIColor(cities.cities[index].aqi),
                      fontSize: 14,
                    ),
                  ),
                  backgroundColor:
                      getAQIColor(cities.cities[index].aqi).withAlpha(40),
                  side: BorderSide.none,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
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
  Widget _buildTableView(SavedCities cities) {
    return ListView(
      padding: const EdgeInsets.all(0.0),
      children: [
        DataTable(
          dataRowMinHeight: 72,
          dataRowMaxHeight: 72,
          horizontalMargin: 0,
          columnSpacing: 24,
          showCheckboxColumn: false,
          columns: const [
            DataColumn(
              label: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child:
                    Text('City', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              numeric: true,
              label: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child:
                    Text('AQI', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              numeric: true,
              label: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text('PM2.5',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              numeric: true,
              label: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child:
                    Text('PM10', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          rows: cities.cities.map((city) {
            bool isLastRow = cities.cities.last == city;
            return DataRow(
              onSelectChanged: (_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedDetail(
                      cityName: city.cityName,
                    ),
                  ),
                );
              },
              cells: [
                DataCell(
                  Container(
                    width: 180,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F3F4),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      city.cityName,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    decoration: isLastRow
                        ? const BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          )
                        : null,
                    child: Text(city.aqi.toString()),
                  ),
                ),
                DataCell(
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    decoration: isLastRow
                        ? const BoxDecoration(
                            color: Colors.teal,
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.5),
                            ),
                          )
                        : null,
                    child: Text(city.pm25.toString()),
                  ),
                ),
                DataCell(
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    decoration: isLastRow
                        ? const BoxDecoration(
                            color: Colors.amber,
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.blue, width: 0.5),
                            ),
                          )
                        : null,
                    child: Text(city.pm10.toString()),
                  ),
                ),
              ],
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildChartView(SavedCities cities) {
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
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
                                  color: Colors.white,
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
                                    color: Colors.white,
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
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "CONDITIONS: ${getAQILabel(cities.cities[index].aqi)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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

  Widget _buildStoryView(SavedCities cities) {
    // TODO: Implement story view
    return const Center(child: Text('Story View Coming Soon'));
  }

  @override
  Widget build(BuildContext context) {
    final cities = context.watch<SavedCities>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Ayer', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: cities.citiesCount() == 0
            ? null
            : [
                PopupMenuButton<ViewType>(
                  tooltip: 'View options',
                  icon: const Icon(Icons.bar_chart),
                  onSelected: (ViewType value) {
                    context.read<SavedCities>().setCurrentView(value);
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<ViewType>(
                      enabled: false,
                      child: Text(
                        'View as',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const PopupMenuItem<ViewType>(
                      value: ViewType.card,
                      child: Text('Default'),
                    ),
                    const PopupMenuItem<ViewType>(
                      value: ViewType.table,
                      child: Text('Table'),
                    ),
                    const PopupMenuItem<ViewType>(
                      value: ViewType.chart,
                      child: Text('Chart'),
                    ),
                    const PopupMenuItem<ViewType>(
                      value: ViewType.story,
                      child: Text('Story'),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    // Handle menu item selection
                    switch (value) {
                      case 'settings':
                        // TODO: Navigate to settings
                        break;
                      case 'about':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AQIBasics()),
                        );
                        break;
                      case 'terms':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TermsOfUse()),
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
                      child: Text('AQI Basics'),
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
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
    );
  }
}
