import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'login/login_form.dart';
import 'home.dart';
import 'air/city_search.dart';
import 'air/city_model.dart';
import 'package:path_provider/path_provider.dart';
import 'design/light_theme.dart';
import 'design/dark_theme.dart';
import 'design/theme_provider.dart';

/// Entry point of the application
/// Loads environment variables and initializes the app with state management
void main() async {
  // Load environment variables from .env file
  await dotenv.load(fileName: '.env');

  // Initialize the app with SavedCities provider for state management
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => SavedCities()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp(),
  ));
}

/// SavedCities is a ChangeNotifier that manages the state of saved cities
/// and their air quality data throughout the app, with persistence support
class SavedCities with ChangeNotifier {
  final List<CityAirData> _cities = [];
  //ViewType _currentView = ViewType.card;

  /// Constructor that initializes by loading saved data
  SavedCities() {
    loadCities();
  }

  /// Loads saved cities from local storage
  Future<void> loadCities() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        _cities.clear();
        _cities.addAll(
          jsonList
              .map((json) => CityAirData.fromJson(json, json['searchTerm']))
              .toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      // Handle error silently - starting with empty list
    }
  }

  /// Saves current cities to local storage
  Future<void> _saveCities() async {
    try {
      final file = await _getLocalFile();
      final jsonList = _cities.map((city) => city.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      // TODO: Handle error
    }
  }

  /// Gets the local file for storing cities data
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/saved_cities.json');
  }

  /// Adds a new city to the saved cities list and persists the change
  void addCity(CityAirData city) {
    _cities.add(city);
    _saveCities();
    // _currentView = ViewType.cards;
    notifyListeners();
  }

  /// Removes a city from the saved cities list and persists the change
  void removeCity(String cityName) {
    _cities.removeWhere((city) => city.cityName == cityName);
    _saveCities();
    notifyListeners();
  }

  /// Getter for list of saved cities
  List<CityAirData> get cities => _cities;

  /// Returns the count of saved cities
  int citiesCount() => _cities.length;
}

/// MyApp is the root widget of the application
/// Sets up the app theme, routes, and initial screen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          // Define named routes for navigation
          routes: {
            '/home': (context) => const HomeScreen(),
            '/login': (context) => const LoginForm(),
            '/search': (context) => const SearchScreen(),
          },
          debugShowCheckedModeBanner: false,
          title: 'Āyer',
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: themeProvider.themeMode,
          home: const MyHomePage(),
        );
      },
    );
  }
}

/// MyHomePage is the initial screen shown when the app launches
/// Displays a splash screen before redirecting to the login screen
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State class for MyHomePage
/// Handles the splash screen timing and navigation
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  /// Delays for 2 seconds then navigates to the login screen
  /// Uses mounted check to prevent navigation after widget disposal
  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginForm()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,
              child: Text(
                'Ā',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Āyer',
              style: TextStyle(fontSize: 32),
            ),
          ],
        ),
      ),
    );
  }
}
