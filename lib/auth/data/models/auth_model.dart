import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;

  AppUser({required this.uid, required this.email});

  factory AppUser.fromFirebase(User user) {
    return AppUser(uid: user.uid, email: user.email ?? '');
  }
}
