// kolej_list_page.dart

import 'package:app2/ReservedPage.dart';
import 'package:app2/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'k9_page.dart';
import 'k10.dart';
import 'kdoj.dart';
import 'ktc.dart';

class KolejListPage extends StatelessWidget {
  final String buttonLabel;
  final String qrCodeData;
  final String userId;

  KolejListPage({Key? key, required this.buttonLabel, required this.qrCodeData, required this.userId}) : super(key: key);
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
        title: const Text('Choose a Kolej'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('KTC'),
            onTap: () {
              // Navigate to the KTC page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => KtcPage(reservationModel: LockerReservationModel(), userId: '', qrCodeData: '', buttonLabel: '',)),
              );
            },
          ),
          ListTile(
            title: const Text('KDOJ'),
            onTap: () {
              // Navigate to the KDOJ page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  KdojPage()),
              );
            },
          ),
          ListTile(
            title: const Text('K9'),
            onTap: () {
              // Navigate to the K9 page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  K9Page()),
              );
            },
          ),
          ListTile(
            title: const Text('K10'),
            onTap: () {
              // Navigate to the K10 page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  K10Page()),
              );
            },
          ),
        ],
      ),      floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with the actual Login Page
        //     );
        //   },
        //   tooltip: 'Sign Out',
        //   heroTag: 'signOut',
        //   child: const Icon(Icons.logout),
        // ),
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
                    userId: user.uid,
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