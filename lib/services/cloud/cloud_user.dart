import 'package:cloud_firestore/cloud_firestore.dart';

class CloudUser {
  final String documentId;
  final String email;
  final String phoneNum;
  final String userId;
  const CloudUser(
      {required this.userId,
      required this.documentId,
      required this.email,
      required this.phoneNum});

  CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        email = snapshot.data()['email'] as String,
        userId = snapshot.data()['userId'] as String,
        phoneNum = snapshot.data()['phoneNum'] as String;
}
