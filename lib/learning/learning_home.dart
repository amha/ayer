import 'package:flutter/material.dart';
import 'package:ayer/learning/aqi_basics.dart';
import 'package:ayer/learning/pollutant_detail.dart';
import 'package:ayer/design/light_theme.dart';

class LearningHome extends StatelessWidget {
  const LearningHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(
            context,
            'AQI Basics',
            [
              LearningItem(
                title: 'Understanding AQI',
                description:
                    'Learn about Air Quality Index and how it affects your health',
                icon: Icons.air,
                route: const AQIBasics(),
              ),
              LearningItem(
                title: 'Health Effects',
                description: 'Understand how air pollution impacts your health',
                icon: Icons.health_and_safety,
                route: const AQIBasics(), // Replace with appropriate screen
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Air Pollutants',
            [
              LearningItem(
                title: 'Particulate Matter',
                description:
                    'Tiny particles in the air that are of various sizes.',
                icon: Icons.coronavirus,
                route: const PollutantDetail(
                  pollutantName: 'PM2.5',
                  details: [
                    'PM2.5 refers to particulate matter that is 2.5 micrometers or less in diameter',
                    'These particles are so small they can only be detected with an electron microscope',
                    'They can penetrate deep into the lungs and even enter the bloodstream',
                    'Major components include sulfate, nitrate, ammonia, and black carbon',
                  ],
                  sources: [
                    'Vehicle emissions, particularly diesel engines',
                    'Power plants and industrial processes',
                    'Wood burning and forest fires',
                    'Construction and demolition activities',
                    'Agricultural operations',
                  ],
                  healthEffects: [
                    'Aggravation of asthma and respiratory symptoms',
                    'Decreased lung function and irregular heartbeat',
                    'Premature death in people with heart or lung disease',
                    'Development of chronic bronchitis',
                    'Increased susceptibility to respiratory infections',
                  ],
                ),
              ),
              LearningItem(
                title: 'Carbon Monoxide (CO)',
                description:
                    'A colorless, odorless, and poisonous gas that can be fatal',
                icon: Icons.wb_sunny,
                route: const PollutantDetail(
                  pollutantName: 'Carbon Monoxide (CO)',
                  details: [
                    'Carbon monoxide is a colorless, odorless gas that can be deadly',
                    'It is produced by the incomplete burning of carbon-based fuels',
                    'CO binds to hemoglobin in blood, reducing oxygen delivery to organs',
                    'Indoor levels can be especially dangerous in poorly ventilated spaces',
                  ],
                  sources: [
                    'Vehicle exhaust, especially in high-traffic areas',
                    'Gas stoves and heating systems',
                    'Tobacco smoke',
                    'Industrial processes',
                    'Wildfires and indoor fires',
                  ],
                  healthEffects: [
                    'Headaches, dizziness, and nausea',
                    'Confusion and disorientation',
                    'Weakness and chest pain',
                    'Unconsciousness at high levels',
                    'Death from severe exposure',
                  ],
                ),
              ),
              LearningItem(
                title: 'Nitrogen dioxide (NO₂)',
                description:
                    'a toxic, reddish-brown gas that contributes to smog and respiratory illness',
                icon: Icons.wb_sunny,
                route: const PollutantDetail(
                  pollutantName: 'Nitrogen Dioxide (NO₂)',
                  details: [
                    'NO₂ is a reddish-brown gas with a strong, harsh odor',
                    'It plays a major role in forming ground-level ozone and fine particle pollution',
                    'Part of a group of pollutants called nitrogen oxides (NOx)',
                    'Can react with other chemicals to form acid rain',
                  ],
                  sources: [
                    'Vehicle emissions',
                    'Power plants and industrial facilities',
                    'Off-road equipment like construction machinery',
                    'Ships and aircraft',
                    'Indoor gas stoves and heaters',
                  ],
                  healthEffects: [
                    'Inflammation of airways',
                    'Coughing and wheezing',
                    'Reduced lung function',
                    'Increased asthma attacks',
                    'Greater susceptibility to respiratory infections',
                  ],
                ),
              ),
              LearningItem(
                title: 'Ozone (O₃)',
                description: 'Understanding ground-level ozone pollution',
                icon: Icons.wb_sunny,
                route: const PollutantDetail(
                  pollutantName: 'Ozone (O₃)',
                  details: [
                    'Ground-level ozone is a harmful air pollutant and the main ingredient in smog',
                    'It forms when pollutants emitted by cars, power plants, and other sources chemically react in sunlight',
                    'Ozone is most likely to reach unhealthy levels on hot sunny days in urban environments',
                  ],
                  sources: [
                    'Vehicle exhaust',
                    'Industrial emissions',
                    'Chemical solvents',
                    'Gasoline vapors',
                    'Electric utilities',
                  ],
                  healthEffects: [
                    'Coughing and throat irritation',
                    'Difficulty breathing and lung inflammation',
                    'Worsening of existing respiratory conditions',
                    'Reduced lung function',
                    'Permanent lung damage with repeated exposure',
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Protection',
            [
              LearningItem(
                title: 'Prevention Tips',
                description: 'Ways to protect yourself from air pollution',
                icon: Icons.shield,
                route: const AQIBasics(), // Replace with appropriate screen
              ),
              LearningItem(
                title: 'Indoor Air Quality',
                description: 'Maintaining clean air in your home',
                icon: Icons.house,
                route: const AQIBasics(), // Replace with appropriate screen
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<LearningItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...items.map((item) => _buildLearningCard(context, item)),
      ],
    );
  }

  Widget _buildLearningCard(BuildContext context, LearningItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardTheme.color ??
        Theme.of(context).colorScheme.surface;
    final titleColor = Theme.of(context).colorScheme.onSurface;
    final subtitleColor = isDark
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.8)
        : Colors.grey[600]!;
    final chevronColor = Theme.of(context).colorScheme.onSurface;

    return Card(
      elevation: 0,
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: ayerAccentColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(
            item.icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: titleColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            item.description,
            style: TextStyle(
              color: subtitleColor,
              fontSize: 14,
            ),
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: chevronColor),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.route),
          );
        },
      ),
    );
  }
}

class LearningItem {
  final String title;
  final String description;
  final IconData icon;
  final Widget route;

  LearningItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });
}
