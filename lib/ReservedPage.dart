//ReservedPage.dart
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ReservedPage extends StatelessWidget {
  final String buttonLabel;
  final String qrCodeData;

  const ReservedPage({Key? key, required this.buttonLabel, required this.qrCodeData})
      : super(key: key);

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
            //Text('Reserved Locker: $buttonLabel'),
            Text('干你老师外国人 老子不想做了TMD'),
          ],
        ),
      ),
    );
  }
}
