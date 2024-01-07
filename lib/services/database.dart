//database.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService(this.uid);

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  Future<void> reserveLocker(String lockerNumber) async {
    // Check if the locker is already reserved
    DocumentSnapshot lockerDoc = await FirebaseFirestore.instance.collection('lockers').doc(lockerNumber).get();

    if (lockerDoc.exists) {
      bool isReserved = (lockerDoc.data() as Map<String, dynamic>)['reserved'];
      if (isReserved) {
        throw Exception('Locker is already reserved.');
      }
    }

    // Check if the user already has a reserved locker
    QuerySnapshot userReservations = await userCollection.where('uid', isEqualTo: uid).get();

    if (userReservations.docs.isNotEmpty) {
      throw Exception('You already have a reserved locker.');
    }

    // Reserve the locker
    await FirebaseFirestore.instance.collection('lockers').doc(lockerNumber).update({'reserved': true, 'reservedBy': uid});

    // Update user's reservation
    await userCollection.doc(uid).set({
      'uid': uid,
      'reservedLocker': lockerNumber,
    });
  }

  Future<void> updateReservationStatus(String lockerNumber, bool isReserved) async {
    // Update the reservation status of the specified locker
    return await FirebaseFirestore.instance
        .collection('lockers')
        .doc(lockerNumber)
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