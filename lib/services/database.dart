//database.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService(this.uid);

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> reserveLocker(String lockerNumber, String uid) async {
    // Check if the locker is already reserved
    DocumentSnapshot lockerDoc = await FirebaseFirestore.instance.collection('lockers').doc(lockerNumber).get();
    print(uid);

    if (lockerDoc.exists) {
      bool isReserved = (lockerDoc.data() as Map<String, dynamic>)['reserved'];
      if (isReserved) {
        throw Exception('Locker is already reserved.');
      }
    }

    // Check if the user already has a reserved locker
    QuerySnapshot userReservations = await userCollection.where('qr', isEqualTo: lockerNumber).get();

    if (userReservations.docs.isNotEmpty) {
      throw Exception('You already have a reserved locker.');
    }

    // Reserve the locker
    await FirebaseFirestore.instance.collection('lockers').doc(lockerNumber).update({'reserved': true, 'reservedBy': uid});
    print('Here');
    print(lockerNumber);
    print(uid);

    // Update user's reservation

    await FirebaseFirestore.instance.collection('users').doc(uid).update({'qr': 'Locker $lockerNumber'});
  }

  Future<void> updateReservationStatus(String lockerNumber, String id, bool isReserved) async {

    String idLatest = '';
    // Update the reservation status of the specified locker

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get();

    if (userDoc.exists) {
      idLatest= userDoc.get('qr') ?? ''; // Fetch QR code from user document
    }

    List<String> parts = idLatest.split(' ');

    // Get the last part of the split string
    String number = parts.last;
    print('haloe');
    print(number);

    await FirebaseFirestore.instance.collection('users').doc(uid).update({'qr': ''});

    return await FirebaseFirestore.instance
        .collection('lockers')
        .doc(number)
        .update({'reserved': isReserved});
  }

  Future updateUserData(String username, String qr) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'username': username,
      'qr': qr,
    });
  }

  Future updateQr(String qr) async {
    return await userCollection.doc(uid).update({
      'qr': qr,
    });
  }

}