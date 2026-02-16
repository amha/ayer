import 'package:ayer/navigation/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:ayer/legal/terms.dart';
import 'package:ayer/legal/privacy.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 150),
            const Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Center(
                child: Text(
                  'Āyer',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Text(
              'Air Quality at your fingertips',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MainShell(),
                          ),
                        );
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicy()),
                      );
                    },
                    child: const Text('Privacy Policy'),
                  ),
                  const SizedBox(width: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsOfUse()),
                      );
                    },
                    child: const Text('Terms of Use'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
