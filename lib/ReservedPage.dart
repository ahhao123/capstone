
//ReservedPage.dart
import 'package:app2/home_page.dart';
import 'package:app2/login_page.dart';
import 'package:app2/services/database.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ReservedPage extends StatelessWidget {
  final String buttonLabel;
  final String qrCodeData;
  final String userId;

  const ReservedPage({Key? key, required this.buttonLabel, required this.qrCodeData, required this.userId})
      : super(key: key);

  Future<void> handleCheckout(BuildContext context) async {
    final String lockerNumber = buttonLabel;
    final String id =  userId;
    final DatabaseService databaseService = DatabaseService(userId);

    // Update reservation status to false (not reserved)
    await databaseService.updateReservationStatus(lockerNumber, id, false);


    // Navigate back to the HomePage after checkout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(buttonLabel: '', qrCodeData: '', userId: '',)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserved Locker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use BarcodeWidget with Barcode.qrCode type
            BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: qrCodeData,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            // Display the locker information or any other relevant details
            Text('Reserved Locker: $qrCodeData'),
            ElevatedButton(
              onPressed: () => handleCheckout(context),
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservedPage(
                    buttonLabel: buttonLabel,
                    qrCodeData: qrCodeData,
                    userId: userId,
                  ),
                ),
              );
            },
            child: const Icon(Icons.qr_code),
          ),
        ],
      ),
    );
  }
}