import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedDetail extends StatefulWidget {
  const FeedDetail({super.key});

  @override
  State<FeedDetail> createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  dynamic _feedData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchFeedData();
  }

  Future<void> _fetchFeedData() async {
    try {
      String url = dotenv.env['BASE_URL'] ?? '';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _feedData = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load data: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Demo Data'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        borderOnForeground: false,
                        child: ListTile(
                          title: const Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                              style: const TextStyle(
                                  fontSize: 48, fontWeight: FontWeight.w300),
                              _feedData['status'] ?? 'N/A'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        borderOnForeground: true,
                        child: ListTile(
                          title: const Text(
                            'AQI',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                              style: const TextStyle(
                                  fontSize: 48, fontWeight: FontWeight.w300),
                              (_feedData['data']['aqi'] ?? 'N/A').toString()),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        borderOnForeground: true,
                        child: ListTile(
                          title: const Text(
                            'City Name',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                              style: const TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.w300),
                              _feedData['data']['city']['name'] ?? 'N/A'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
