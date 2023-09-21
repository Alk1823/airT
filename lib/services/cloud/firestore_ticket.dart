import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AirTours/services/cloud/cloud_ticket.dart';

import '../../constants/flight_constants.dart';
import '../../constants/ticket_constants.dart';

class TicketFirestore {
  final tickets = FirebaseFirestore.instance.collection('tickets');
  final flights = FirebaseFirestore.instance.collection('flights');
  static final TicketFirestore _shared = TicketFirestore._sharedInstance();

  TicketFirestore._sharedInstance();

  factory TicketFirestore() => _shared;

  Stream<Iterable<CloudTicket>> allTickets(
      {required String bookingId, required String flightId}) {
    final allTickets = tickets
        .where(bookingReferenceField, isEqualTo: bookingId)
        .where(flightRefField, isEqualTo: flightId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudTicket.fromSnapshot(doc)));
    return allTickets;
  }

  Future<CloudTicket> createNewTicket(
      {required String firstName,
      required String middleName,
      required bool checkInStatus,
      required int bagQuantity,
      required String mealType,
      required String lastName,
      required double ticketPrice,
      required String bookingReference,
      required String ticketUserId,
      required DateTime birthDate,
      required String flightReference,
      required String ticketClass}) async {
    Timestamp birthdateStamp = Timestamp.fromDate(birthDate);

    final document = await tickets.add({
      ticketClassField: ticketClass,
      ticketPriceField: ticketPrice,
      checkInStatusField: checkInStatus,
      flightRefField: flightReference,
      firstNameField: firstName,
      middleNameField: middleName,
      lastNameField: lastName,
      bagQuantityField: bagQuantity,
      mealTypeField: mealType,
      ticketUserIdField: ticketUserId,
      birthDateField: birthdateStamp,
      bookingReferenceField: bookingReference
    });
    final fetchedTicket = await document.get();
    return CloudTicket(
        documentId: fetchedTicket.id,
        firstName: firstName,
        middleName: middleName,
        checkInStatus: checkInStatus,
        bagQuantity: bagQuantity,
        mealType: mealType,
        lastName: lastName,
        ticketPrice: ticketPrice,
        bookingReference: bookingReference,
        ticketUserId: ticketUserId,
        birthDate: birthdateStamp,
        flightReference: flightReference,
        ticketClass: ticketClass);
  }

  Future<bool> checkInUpdating(String ticketId, String flightId) async {
    try {
      DateTime now = DateTime.now();
      print('$ticketId , $flightId');
      final tempFlight = flights.doc(flightId);
      final fetchedFlight = await tempFlight.get();
      final tempTicket = tickets.doc(ticketId);

      if (fetchedFlight.exists) {
        print('ok');
        DateTime flightDate = fetchedFlight.data()![depDateField].toDate();
        DateTime flightTime = fetchedFlight.data()![depTimeField].toDate();
        DateTime totalTime = DateTime(flightDate.year, flightDate.month,
            flightDate.day, flightTime.hour, flightTime.minute);
        print(totalTime);
        Duration timeDifference = totalTime.difference(now);
        print(timeDifference);
        if (timeDifference.inHours <= 24) {
          await tempTicket.update({checkInStatusField: true});

          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}