class FirebaseUser {
  final String uid;
  FirebaseUser(this.uid);
}

class UserData {
  final String uid;
  final String username;
  final String qr;

  UserData({
    required this.uid,
    required this.username,
    required this.qr,
  });
}