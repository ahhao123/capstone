import 'package:app2/ReservedPage.dart';
import 'package:app2/login_page.dart';
import 'package:flutter/material.dart';

class K9Page extends StatelessWidget {
  final List<String> lockerNumbers = ['1', '2', '3', '4'];

   K9Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('K9 Locker List'),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: ListView.builder(
          itemCount: lockerNumbers.length,
          itemBuilder: (BuildContext context, int index) {
            return buildLockerItem(context, lockerNumbers[index]);
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

  Widget buildLockerItem(BuildContext context, String lockerNumber) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        onTap: () {
          _showReservedDialog(context, lockerNumber);
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Locker $lockerNumber'),
            const Text('Not Available', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  void _showReservedDialog(BuildContext context, String lockerNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Locker Reserved'),
          content: Text('Locker $lockerNumber has been reserved!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
