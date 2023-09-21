
import 'auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
  Future<void> updateUserEmail({
    required String email
  });
  Future<void> updateUserPassword({
    required String password
  });
  Future<void> deleteAccount();
}
