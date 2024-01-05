//home.dart
import 'package:flutter/material.dart';
import 'kolej_list_page.dart'; // Import the KolejListPage
import 'login_page.dart';
import 'package:app2/ReservedPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the KolejListPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KolejListPage()),
                );
              },
              child: const Text('Vacancy'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Replace with the action for the "Monitor" button
                print('Navigate to Monitor page');
              },
              child: const Text('Monitor'),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // Replace with the actual Login Page
              );
            },
            tooltip: 'Sign Out',
            heroTag: 'signOut',
            child: Icon(Icons.logout),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservedPage(buttonLabel: '', qrCodeData: '',)), // Replace with the actual Reserved Page
              );
            },
            tooltip: 'Reserved Page',
            heroTag: 'reservedPage',
            child: Icon(Icons.qr_code),
          ),
        ],
      ),
    );
  }
}