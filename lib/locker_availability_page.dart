// locker_availability_page.dart

import 'package:flutter/material.dart';

class LockerAvailabilityPage extends StatelessWidget {
  const LockerAvailabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locker Availability'),
      ),
      body: const Center(
        child: Text('This is the Locker Availability Page'),
      ),
    );
  }
}
