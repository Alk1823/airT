import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String id;
  final String email;
  const AuthUser(
      {required this.isEmailVerified, required this.id, required this.email});

  factory AuthUser.fromFirebase(User user) => AuthUser(
      isEmailVerified: user.emailVerified, id: user.uid, email: user.email!);
}
