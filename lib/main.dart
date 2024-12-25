import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'login/login_form.dart';
import 'home.dart';
import 'air/air_search.dart';
import 'air/city_air_data.dart';
import 'design/ayer_text.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  runApp(ChangeNotifierProvider(
      create: (context) => SavedCities(), child: const MyApp()));
}

class SavedCities with ChangeNotifier {
  List<CityAirData> _cities = [];

  void addCity(CityAirData city) {
    _cities.add(city);
    notifyListeners();
  }

  void removeCity(String cityName) {
    _cities.removeWhere((city) => city.cityName == cityName);
    notifyListeners();
  }

  List<CityAirData> get cities => _cities;

  int citiesCount() {
    return _cities.length;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginForm(),
        '/search': (context) => const SearchScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Āyer',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: ayerTextTheme,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
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
        child: Text(
          'Āyer',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
