import 'package:flutter/material.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Terms of Use'),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
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
                'Introduction',
                'Welcome to Āyer. By using our app, you agree to these terms. Please read them carefully.',
              ),
              _buildSection(
                context,
                'Using our Services',
                'You must follow any policies made available to you within the Services. You may use our Services only as permitted by law. We may suspend or stop providing our Services to you if you do not comply with our terms or policies.',
              ),
              _buildSection(
                context,
                'Data Usage',
                'Our app collects and displays air quality data from various sources. While we strive for accuracy, we cannot guarantee the absolute accuracy of this data.',
              ),
              _buildSection(
                context,
                'Privacy',
                'Our privacy policy explains how we treat your personal data and protect your privacy when you use our Services. By using our Services, you agree that we can use such data in accordance with our privacy policies.',
              ),
              _buildSection(
                context,
                'Liability',
                'When permitted by law, Āyer and its suppliers and distributors will not be responsible for lost profits, revenues, or data, financial losses or indirect, special, consequential, exemplary, or punitive damages.',
              ),
              _buildSection(
                context,
                'Changes to Terms',
                'We may modify these terms or any additional terms that apply to a Service to, for example, reflect changes to the law or changes to our Services.',
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
