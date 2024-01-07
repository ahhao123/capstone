// ktc.dart

import 'package:app2/login_page.dart';
import 'package:app2/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2/ReservedPage.dart';

class LockerReservationModel with ChangeNotifier {
  List<bool> buttonStates = [false, false, false, false];

  Future<void> reserveLocker(int index, String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String lockerNumber = (index + 1).toString();
    final DocumentReference lockerRef = firestore.collection('lockers').doc(lockerNumber);
    final DatabaseService databaseService = DatabaseService(userId);

    try {
      // Check if the locker is already reserved
      DocumentSnapshot lockerDoc = await lockerRef.get();
      if (lockerDoc.exists) {
        String reservedBy = (lockerDoc.data() as Map<String, dynamic>)['reservedBy'];
        if (reservedBy.isNotEmpty) {
          // Locker is already reserved by another user
          print('Locker $lockerNumber is already reserved by $reservedBy');
          return;
        }
      }

      // Attempt to reserve the locker
      await databaseService.reserveLocker(lockerNumber);

      // If reservation is successful, update the UI and Firestore
      buttonStates[index] = true;
      await lockerRef.update({
        'reserved': true,
        'reservedBy': userId,
      });

      notifyListeners();
    } catch (e) {
      // Handle reservation errors (e.g., locker already reserved, user already has a reserved locker)
      print('Reservation Error: $e');
    }
  }
}

class KtcPage extends StatelessWidget {
  final List<String> lockerNumbers = ['1', '2', '3', '4'];
  final LockerReservationModel reservationModel;
  final String userId; // Add this parameter

  KtcPage({super.key, required this.reservationModel, required this.userId});
  final FirebaseAuth auth = FirebaseAuth.instance;

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
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('lockers')
                  .doc(lockerNumbers[index])
                  .get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Or any other loading indicator
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text('Document does not exist');
                }
                // Retrieve the 'reserved' status from Firestore
                bool isReserved = (snapshot.data!.data() as Map<String, dynamic>)['reserved'];
                bool isReservedByCurrentUser = (snapshot.data!.data() as Map<String, dynamic>)['reservedBy'] == userId;

                return buildLockerItem(
                  context,
                  lockerNumbers[index],
                  index,
                  isReserved,
                  isReservedByCurrentUser,
                );
              },
            );
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
                MaterialPageRoute(builder: (context) => ReservedPage(buttonLabel: '', qrCodeData: '', userId: userId,)), // Replace with the actual Reserved Page
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

  Widget buildLockerItem(BuildContext context, String lockerNumber, int index, bool isReserved, bool isReservedByCurrentUser) {
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
              isReserved ? 'Not Available' : 'Available',
              style: TextStyle(
                color: isReserved ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
        subtitle: isReservedByCurrentUser ? const Text('Reserved by You') : null,
      ),
    );
  }

  Future<void> _showReservationConfirmationDialog(BuildContext context, String lockerNumber, int index) async {
    try {
      final DocumentReference lockerRef = FirebaseFirestore.instance.collection('lockers').doc(lockerNumber);
      DocumentSnapshot lockerDoc = await lockerRef.get();

      if (lockerDoc.exists && (lockerDoc.data() as Map<String, dynamic>)['reserved']) {
        // Locker is already reserved
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Locker Already Reserved'),
              content: Text('Locker $lockerNumber has already been reserved.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the pop-up window
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Locker is available, show confirmation dialog
        bool userConfirmed = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Reservation Confirmation'),
              content: Text('Do you want to reserve Locker $lockerNumber?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // User confirmed
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // User declined
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );

        if (userConfirmed) {
          // Proceed with reservation
          await reservationModel.reserveLocker(index, userId);

          // Show a pop-up window for successful reservation
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Reservation Successful'),
                content: Text('Locker $lockerNumber has been reserved!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the pop-up window
                      // Navigate to the ReservedPage after reserving
                      _navigateToReservedPage(context, lockerNumber, userId);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      // Handle reservation errors
      print('Reservation Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Reservation Failed'),
            content: Text('Failed to reserve Locker $lockerNumber. $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the pop-up window
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _navigateToReservedPage(BuildContext context, String lockerNumber, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservedPage(buttonLabel: lockerNumber, qrCodeData: '', userId: userId),
      ),
    );
  }
}
