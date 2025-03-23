import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Last updated: May 8, 2024',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                'Information We Collect',
                'We collect information about your location and the cities you choose to monitor for air quality data. This helps us provide you with relevant air quality information.',
              ),
              _buildSection(
                context,
                'How We Use Your Information',
                'We use the information we collect to provide and improve our air quality monitoring services, send you notifications about air quality changes, and maintain and enhance the app.',
              ),
              _buildSection(
                context,
                'Data Storage',
                'Your selected cities and preferences are stored locally on your device. We do not store personal information on our servers.',
              ),
              _buildSection(
                context,
                'Third-Party Services',
                'We use third-party air quality data providers. When you use our app, you\'re also subject to their privacy policies. We recommend reviewing their privacy practices.',
              ),
              _buildSection(
                context,
                'Your Rights',
                'You can delete your saved cities and preferences at any time through the app settings. You can also choose to stop using our services at any time.',
              ),
              _buildSection(
                context,
                'Changes to Policy',
                'We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page.',
              ),
              _buildSection(
                context,
                'Contact Us',
                'If you have any questions about this Privacy Policy, please contact us at privacy@ayer.app',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
