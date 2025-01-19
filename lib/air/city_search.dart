import 'package:flutter/material.dart';
import 'city_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Example list of strings - replace with your actual data
  final List<String> items = [
    'New York City',
    'Montreal',
    'Addis Ababa',
    'Athens',
    'Paris',
  ];

  List<String> filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  // void _filterItems(String query) {
  //   setState(() {
  //     filteredItems = items
  //         .where((item) => item.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('About this search'),
                    content: const Text(
                        'Āyer uses the World Air Quality project\'s APIs to provide air quality data.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          _launchURL('https://aqicn.org/faq/');
                          Navigator.of(context).pop();
                        },
                        child: const Text('Learn More'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              //onChanged: _filterItems,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedDetail(cityName: value),
                    ),
                  );
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: filteredItems.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         title: Text(filteredItems[index],
          //             style: const TextStyle(
          //                 fontSize: 18, fontWeight: FontWeight.w400)),
          //         trailing: const Icon(Icons.arrow_forward_ios),
          //         onTap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) =>
          //                   FeedDetail(cityName: filteredItems[index]),
          //             ),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
