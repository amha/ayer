import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../design/theme_provider.dart';
import '../legal/privacy.dart';
import '../legal/terms.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Theme'),
            subtitle: Text(themeProvider.isDarkMode ? 'Dark' : 'Light'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: const Text('Select a theme'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<bool>(
                          title: const Text('Light'),
                          value: false,
                          groupValue: themeProvider.isDarkMode,
                          onChanged: (bool? value) {
                            if (value != null) {
                              themeProvider.toggleTheme(value);
                              Navigator.pop(context);
                            }
                          },
                        ),
                        RadioListTile<bool>(
                          title: const Text('Dark'),
                          value: true,
                          groupValue: themeProvider.isDarkMode,
                          onChanged: (bool? value) {
                            if (value != null) {
                              themeProvider.toggleTheme(value);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.check),
            title: Text('AQI Service'),
            subtitle: Text('Select the AQI service you want'),
          ),
          Divider(
            indent: 16,
            color: Theme.of(context).dividerColor,
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            subtitle: const Text('Legal stuff'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Use'),
            subtitle: const Text('More legal stuff'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsOfUse()),
              );
            },
          ),

          // Add more settings options as needed
        ],
      ),
    );
  }
}
