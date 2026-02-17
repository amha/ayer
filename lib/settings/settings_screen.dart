import 'package:flutter/cupertino.dart';
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
    final accentColor = Theme.of(context).colorScheme.primary;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : CupertinoColors.systemGroupedBackground,
      body: CustomScrollView(
        primary: false,
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: CupertinoListSection.insetGrouped(
              header: const Text('Appearance'),
              children: [
                CupertinoListTile.notched(
                  leading: Container(
                    width: 29,
                    height: 29,
                    alignment: Alignment.center,
                    child: Icon(
                      CupertinoIcons.moon_fill,
                      color: accentColor,
                    ),
                  ),
                  title: const Text('Dark Mode'),
                  trailing: CupertinoSwitch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: CupertinoListSection.insetGrouped(
              header: const Text('Data'),
              children: [
                CupertinoListTile.notched(
                  leading: Container(
                    width: 29,
                    height: 29,
                    alignment: Alignment.center,
                    child: Icon(
                      CupertinoIcons.cloud_fill,
                      color: accentColor,
                    ),
                  ),
                  title: const Text('AQI Service'),
                  additionalInfo: const Text('World Air Quality'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    // TODO: Navigate to AQI service selection
                  },
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: CupertinoListSection.insetGrouped(
              header: const Text('Legal'),
              children: [
                CupertinoListTile.notched(
                  leading: Container(
                    width: 29,
                    height: 29,
                    alignment: Alignment.center,
                    child: Icon(
                      CupertinoIcons.lock_shield_fill,
                      color: accentColor,
                    ),
                  ),
                  title: const Text('Privacy Policy'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const PrivacyPolicy(),
                      ),
                    );
                  },
                ),
                CupertinoListTile.notched(
                  leading: Container(
                    width: 29,
                    height: 29,
                    alignment: Alignment.center,
                    child: Icon(
                      CupertinoIcons.doc_text_fill,
                      color: accentColor,
                    ),
                  ),
                  title: const Text('Terms of Use'),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const TermsOfUse(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
