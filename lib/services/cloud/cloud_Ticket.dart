import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/ticket_constants.dart';

class CloudTicket {
  final String documentId;
  final String firstName;
  final String middleName;
  final String lastName;
  final bool checkInStatus;
  final int bagQuantity;
  final String mealType;
  final double ticketPrice;
  final String bookingReference;
  final String ticketUserId;
  final Timestamp birthDate;
  final String flightReference;
  final String ticketClass;

  CloudTicket(
      {required this.documentId,
      required this.firstName,
      required this.middleName,
      required this.checkInStatus,
      required this.bagQuantity,
      required this.mealType,
      required this.lastName,
      required this.ticketPrice,
      required this.bookingReference,
      required this.ticketUserId,
      required this.birthDate,
      required this.flightReference,
      required this.ticketClass});

  CloudTicket.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        firstName = snapshot.data()[firstNameField] as String,
        middleName = snapshot.data()[middleNameField] as String,
        lastName = snapshot.data()[lastNameField] as String,
        checkInStatus = snapshot.data()[checkInStatusField] as bool,
        flightReference = snapshot.data()[flightRefField] as String,
        birthDate = snapshot.data()[birthDateField] as Timestamp,
        ticketUserId = snapshot.data()[ticketUserIdField] as String,
        ticketPrice = snapshot.data()[ticketPriceField] as double,
        bookingReference = snapshot.data()[bookingReferenceField] as String,
        mealType = snapshot.data()[mealTypeField] as String,
        ticketClass = snapshot.data()[ticketClassField] as String,
        bagQuantity = snapshot.data()[bagQuantityField] as int;
}
