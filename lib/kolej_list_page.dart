// kolej_list_page.dart

import 'package:app2/ReservedPage.dart';
import 'package:app2/login_page.dart';
import 'package:flutter/material.dart';
import 'k9_page.dart';
import 'k10.dart';
import 'kdoj.dart';
import 'ktc.dart';

class KolejListPage extends StatelessWidget {
  const KolejListPage({Key? key}) : super(key: key);

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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReservedPage(buttonLabel: '', qrCodeData: '', userId: '',)), // Replace with the actual Reserved Page
            );
          },
          tooltip: 'Reserved Page',
          heroTag: 'reservedPage',
          child: const Icon(Icons.qr_code),
        ),
      ],
    ),
    );
  }
}