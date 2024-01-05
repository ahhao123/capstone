//ktc.dart
import 'package:app2/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2/ReservedPage.dart';

class LockerReservationModel with ChangeNotifier {
  List<bool> buttonStates = [false, false, false, false];

  Future<void> reserveLocker(int index) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String lockerNumber = (index + 1).toString();
    final DocumentReference lockerRef = firestore.collection('lockers').doc(lockerNumber);


    // Check Firebase for availability before reserving
    DocumentSnapshot lockerDoc = await lockerRef.get();

    if (lockerDoc.exists && !(lockerDoc.data() as Map<String, dynamic>)['reserved']) {
      // Locker is available, reserve it
      await lockerRef.update({'reserved': true});

      String qrCodeData = 'Locker $lockerNumber';
      await firestore.collection('reservations').doc().set({
        'lockerNumber': lockerNumber,
        'qrCodeData': qrCodeData,
        // Add other relevant information
      });

      buttonStates[index] = true;
      notifyListeners(); // Ensure this line is present
    }
  }
}

class KtcPage extends StatelessWidget {
  final List<String> lockerNumbers = ['1', '2', '3', '4'];
  final LockerReservationModel reservationModel;

  KtcPage({super.key, required this.reservationModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KTC Locker List'),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: ListView.builder(
          itemCount: lockerNumbers.length,
          itemBuilder: (BuildContext context, int index) {
            return buildLockerItem(context, lockerNumbers[index], index);
          },
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

  Widget buildLockerItem(BuildContext context, String lockerNumber, int index) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        onTap: () async {
          await _showReservationConfirmationDialog(context, lockerNumber, index);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Locker $lockerNumber'),
            Text(
              reservationModel.buttonStates[index] ? 'Not Available' : 'Available',
              style: TextStyle(
                color: reservationModel.buttonStates[index] ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _showReservationConfirmationDialog(BuildContext context,
      String lockerNumber, int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reservation Confirmation'),
          content: Text('Do you want to reserve Locker $lockerNumber?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Reserve the locker
                  reservationModel.reserveLocker(index);
                // Generate QR code data (you may use locker number or a reservation ID)
                String qrCodeData = 'Locker $lockerNumber';
                // Navigate to the ReservedPage after reserving
                _navigateToReservedPage(context, lockerNumber,qrCodeData);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToReservedPage(BuildContext context, String lockerNumber, String qrCodeData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservedPage(buttonLabel: lockerNumber, qrCodeData: qrCodeData),
      ),
    );
  }
}


