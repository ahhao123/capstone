// home_page.dart

import 'package:flutter/material.dart';
import 'locker_availability_page.dart';
import 'monitoring_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LockerAvailabilityPage()),
                );
              },
              child: const Text('Locker Availability'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MonitoringPage()),
                );
              },
              child: const Text('Monitoring'),
            ),
          ],
        ),
      ),
    );
  }
}
