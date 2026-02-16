import 'package:flutter/material.dart';
import 'city_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _suggestedCities = [
    'New York City',
    'London',
    'Addis Ababa',
    'Seoul',
    'Paris',
    'Montreal',
    'Athens',
    'Tokyo',
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onCitySelected(String cityName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedDetail(cityName: cityName),
      ),
    );
  }

  void _onAutoDetect() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location detection coming soon. Enter a city below.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final mutedColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Search icon (white background, black icon in light mode)
            Builder(
              builder: (context) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Theme.of(context).cardColor
                        : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.search,
                    size: 40,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              'Find cities around you',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              'Click auto-find or enter a city to check air quality',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: mutedColor,
                    fontSize: 14,
                  ),
            ),
            const SizedBox(height: 32),
            // Auto-detect button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _onAutoDetect,
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Nearest Location Detection'),
              ),
            ),
            const SizedBox(height: 24),
            // Or separator
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Or',
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // City input field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                hintStyle: TextStyle(color: mutedColor),
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: mutedColor,
                  size: 22,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _onCitySelected(value.trim());
                }
              },
            ),
            const SizedBox(height: 32),
            // Suggested cities list
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Suggested cities',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _suggestedCities.map((cityName) {
                return _CityPill(
                  cityName: cityName,
                  onTap: () => _onCitySelected(cityName),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _CityPill extends StatelessWidget {
  final String cityName;
  final VoidCallback onTap;

  const _CityPill({
    required this.cityName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pillColor = isDark ? Theme.of(context).cardColor : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Text(
            cityName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
