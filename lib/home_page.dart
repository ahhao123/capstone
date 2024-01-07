//home.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'kolej_list_page.dart'; // Import the KolejListPage
import 'login_page.dart';
import 'package:app2/ReservedPage.dart';


class HomePage extends StatelessWidget {
  final String buttonLabel;
  final String qrCodeData;
  final String userId;

  HomePage({super.key, required this.buttonLabel, required this.qrCodeData, required this.userId});
  Future<String> getCurrentUserQR(String userId) async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.get('qr') ?? ''; // Fetch QR code from user document
      }
      return '';
    } catch (e) {
      print('Error fetching user QR: $e');
      return '';
    }
  }
  final FirebaseAuth auth = FirebaseAuth.instance;

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
                  MaterialPageRoute(builder: (context) => KolejListPage(buttonLabel: '', qrCodeData: '', userId: '',)),
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
                MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with the actual Login Page
              );
            },
            tooltip: 'Sign Out',
            heroTag: 'signOut',
            child: const Icon(Icons.logout),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () async {
              final User? user = auth.currentUser;
              String currentUserQR = await getCurrentUserQR(user!.uid); // Fetch current user's QR code
              print('Second Here');
              print(currentUserQR);

              if (currentUserQR.isNotEmpty) {
                // Update qrCodeData with the fetched QR code

                // Navigate to the ReservedPage with the updated qrCodeData
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservedPage(
                      buttonLabel: buttonLabel,
                      qrCodeData: currentUserQR, // Pass the updated qrCodeData
                      userId: user!.uid,
                    ),
                  ),
                );
              } else {
                print('No QR code data found for the current user');
                // Handle the case where no QR code data is available for the user
                // You can show a message or take appropriate action here
              }
            },
            child: const Icon(Icons.qr_code),
          ),
        ],
      ),
    );
  }
}