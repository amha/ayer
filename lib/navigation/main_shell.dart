import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_tabbar_minimize/liquid_tabbar_minimize.dart';
import 'package:ayer/home.dart';
import 'package:ayer/devices/device_list.dart';
import 'package:ayer/learning/learning_home.dart';
import 'package:ayer/air/city_search.dart';
import 'package:ayer/settings/settings_screen.dart';
import 'package:ayer/design/light_theme.dart';

/// Main app shell with iOS 26-style bottom navigation.
/// Uses liquid_tabbar_minimize for scroll-aware minimize behavior.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  double _lastScrollOffset = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    DeviceList(),
    LearningHome(),
    SearchScreen(),
    SettingsScreen(),
  ];

  static const List<String> _tabTitles = [
    'Dashboard',
    'Sensors',
    'AQI',
    'Search',
    'Settings',
  ];

  static const List<LiquidTabItem> _tabItems = [
    LiquidTabItem(
      widget: Icon(Icons.space_dashboard_outlined),
      selectedWidget: Icon(Icons.space_dashboard),
      sfSymbol: 'square.grid.2x2',
      selectedSfSymbol: 'square.grid.2x2.fill',
      label: 'Dashboard',
    ),
    LiquidTabItem(
      widget: Icon(Icons.device_thermostat_outlined),
      selectedWidget: Icon(Icons.device_thermostat),
      sfSymbol: 'sensor',
      selectedSfSymbol: 'sensor.fill',
      label: 'Sensors',
    ),
    LiquidTabItem(
      widget: Icon(Icons.air_outlined),
      selectedWidget: Icon(Icons.air),
      sfSymbol: 'wind',
      selectedSfSymbol: 'wind',
      label: 'AQI',
    ),
    LiquidTabItem(
      widget: Icon(Icons.search),
      selectedWidget: Icon(Icons.search),
      sfSymbol: 'magnifyingglass',
      selectedSfSymbol: 'magnifyingglass',
      label: 'Search',
    ),
    LiquidTabItem(
      widget: Icon(Icons.settings_outlined),
      selectedWidget: Icon(Icons.settings),
      sfSymbol: 'gearshape',
      selectedSfSymbol: 'gearshape.fill',
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        largeTitle: Text(_tabTitles[_selectedIndex]),
        automaticallyImplyLeading: false,
      ),
      child: Column(
        children: [
          Expanded(
            child: SafeArea(
              top: true,
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      final offset = notification.metrics.pixels;
                      final delta = offset - _lastScrollOffset;
                      LiquidBottomNavigationBar.handleScroll(offset, delta);
                      _lastScrollOffset = offset;
                    }
                    return false;
                  },
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _screens,
                  ),
                ),
              ),
            ),
          ),
          LiquidBottomNavigationBar(
            currentIndex: _selectedIndex,
            items: _tabItems,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _lastScrollOffset = 0;
              });
            },
            selectedItemColor: ayerAccentColor,
            unselectedItemColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            labelVisibility: LabelVisibility.always,
            enableMinimize: true,
            height: 68,
            bottomOffset: 8,
          ),
        ],
      ),
    );
  }
}
