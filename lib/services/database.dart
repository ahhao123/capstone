import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService(this.uid);

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

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