import 'package:AirTours/constants/flight_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AirTours/services/cloud/cloud_booking.dart';
import 'package:AirTours/constants/booking_constants.dart';

import '../../constants/ticket_constants.dart';

class BookingFirestore {
  final bookings = FirebaseFirestore.instance.collection('bookings');
  final flights = FirebaseFirestore.instance.collection('flights');
  final tickets = FirebaseFirestore.instance.collection('tickets');

  static final BookingFirestore _shared = BookingFirestore._sharedInstance();
  BookingFirestore._sharedInstance();
  factory BookingFirestore() => _shared;

  Future<bool> upgradeOneWay({
    required String bookingId,
    required String departureFlightId,
    required int numOfPas,
  }) async {
    try {
      bool flag = false;
      final depFlight = flights.doc(departureFlightId);
      final fetchedDep = await depFlight.get();

      if (fetchedDep.exists) {
        DateTime flightDate = fetchedDep.data()![depDateField].toDate();
        DateTime flightTime = fetchedDep.data()![depTimeField].toDate();
        DateTime totalTime = DateTime(
          flightDate.year,
          flightDate.month,
          flightDate.day,
          flightTime.hour,
          flightTime.minute,
        );

        if (DateTime.now().isBefore(totalTime)) {
          int currentBus1 = fetchedDep.data()![numOfAvabusField];
          double busSeatPrice1 = fetchedDep.data()![busPriceField];
          if (currentBus1 >= numOfPas) {
            decreaseNumberOfSeats(departureFlightId, numOfPas, 'business');

            increaseNumberOfSeats(departureFlightId, numOfPas, 'guest');

            double totalPrice = await updateRelatedTickets(
              flightId: departureFlightId,
              bookingId: bookingId,
              ticketPrice: busSeatPrice1,
            );

            bookings.doc(bookingId).update({
              bookingPriceField: totalPrice,
              bookingClassField: 'business',
            });

            flag = true;
            return flag;
          } else {
            return flag; // no seats
          }
        }
      }
      return flag;
    } catch (e) {
      print('Error occurred w seat availability: $e');
      return false;
    }
  }

  Future<bool> upgradeRoundTrip({
    required String bookingId,
    required String departureFlightId,
    required String returnFlightId,
    required int numOfPas,
  }) async {
    try {
      bool flag = false;
      final depFlight = flights.doc(departureFlightId);
      final fetchedDep = await depFlight.get();
      final retFlight = flights.doc(returnFlightId);
      final fetchedRet = await retFlight.get();

      if (fetchedDep.exists) {
        if (fetchedRet.exists) {
          DateTime flightDate = fetchedDep.data()![depDateField].toDate();
          DateTime flightTime = fetchedDep.data()![depTimeField].toDate();
          DateTime totalTime = DateTime(flightDate.year, flightDate.month,
              flightDate.day, flightTime.hour, flightTime.minute);

          if (DateTime.now().isBefore(totalTime)) {
            int currentBus1 = fetchedDep.data()![numOfAvabusField];
            int currentBus2 = fetchedRet.data()![numOfAvabusField];
            double busSeatPrice1 = fetchedDep.data()![busPriceField];
            double busSeatPrice2 = fetchedRet.data()![busPriceField];
            if (currentBus1 >= numOfPas && currentBus2 >= numOfPas) {
              decreaseNumberOfSeats(departureFlightId, numOfPas, 'business');
              decreaseNumberOfSeats(returnFlightId, numOfPas, 'business');
              increaseNumberOfSeats(departureFlightId, numOfPas, 'guest');
              increaseNumberOfSeats(returnFlightId, numOfPas, 'guest');
              double totalPrice1 = await updateRelatedTickets(
                  flightId: departureFlightId,
                  bookingId: bookingId,
                  ticketPrice: busSeatPrice1);
              double totalPrice2 = await updateRelatedTickets(
                  flightId: returnFlightId,
                  bookingId: bookingId,
                  ticketPrice: busSeatPrice2);
              double totalPrice = totalPrice1 + totalPrice2;
              print(totalPrice);
              bookings.doc(bookingId).update({
                bookingPriceField: totalPrice,
                bookingClassField: 'business'
              });

              flag = true;
              return flag;
            } else {
              return flag; //no seats
            }
          }
        }
      }
      return flag;
    } catch (e) {
      print('Error occurred w seat availability: $e');
      return false;
    }
  }

  Future<bool> deleteBooking({
    required String bookingId,
    required String flightId1,
    required String flightId2,
    required String flightClass,
    required int numOfPas,
  }) async {
    try {
      bool flag = false;
      DateTime now = DateTime.now();
      final tmpBooking = bookings.doc(bookingId);
      final tempFlight = flights.doc(flightId1);
      final fetchedFlight = await tempFlight.get();
      DateTime flightDate = fetchedFlight.data()![depDateField].toDate();
      DateTime flightTime = fetchedFlight.data()![depTimeField].toDate();
      DateTime totalTime = DateTime(flightDate.year, flightDate.month,
          flightDate.day, flightTime.hour, flightTime.minute);

      if (now.isBefore(totalTime)) {
        if (fetchedFlight.exists) {
          Duration timeDifference = totalTime.difference(now);

          if (timeDifference.inHours >= 24) {
            await tmpBooking.delete();
            increaseNumberOfSeats(flightId1, numOfPas, flightClass);

            flag = true;
            await deleteRelatedTickets(bookingId: bookingId);
            //roundtrip
            if (flightId2 != 'none') {
              increaseNumberOfSeats(flightId2, numOfPas, flightClass);
            }
          }
        }
      }
      return flag;
    } catch (e) {
      return false;
    }
  }

  Stream<Iterable<CloudBooking>> allBookings({required String bookingUserId}) {
    final allBookings = bookings
        .where(bookingUserIdField, isEqualTo: bookingUserId)
        .snapshots()
        .map(
            (event) => event.docs.map((doc) => CloudBooking.fromSnapshot(doc)));
    return allBookings;
  }

  Future<CloudBooking> createNewBooking(
      {required String bookingClass,
      required double bookingPrice,
      required String departureFlight,
      required String returnFlight,
      required int numOfSeats,
      required DateTime bookingTime,
      required String bookingUserId}) async {
    Timestamp bookingTimestamp = Timestamp.fromDate(bookingTime);

    final document = await bookings.add({
      bookingClassField: bookingClass,
      bookingPriceField: bookingPrice,
      departureFlightField: departureFlight,
      returnFlightField: returnFlight,
      bookingUserIdField: bookingUserId,
      numOfSeatsField: numOfSeats,
      bookingTimeField: bookingTimestamp
    });
    decreaseNumberOfSeats(departureFlight, numOfSeats, bookingClass);
    if (returnFlight != 'none') {
      decreaseNumberOfSeats(returnFlight, numOfSeats, bookingClass);
    }

    final fetchedBooking = await document.get();
    return CloudBooking(
        documentId: fetchedBooking.id,
        bookingPrice: bookingPrice,
        bookingClass: bookingClass,
        departureFlight: departureFlight,
        returnFlight: returnFlight,
        bookingUserId: bookingUserId,
        numOfSeats: numOfSeats,
        bookingTime: bookingTimestamp);
  }

  Future<void> decreaseNumberOfSeats(
      String flightId, int numOfSeats, String flightClass) async {
    try {
      final tempFlight = flights.doc(flightId);
      final fetchedFlight = await tempFlight.get();

      if (flightClass == 'business') {
        int currentSeats = fetchedFlight.data()![numOfAvabusField];
        if (currentSeats > 0) {
          int newSeats = currentSeats - numOfSeats;
          tempFlight.update({numOfAvabusField: newSeats});
        }
      } else {
        int currentSeats = fetchedFlight.data()![numOfAvaGueField];
        if (currentSeats > 0) {
          int newSeats = currentSeats - numOfSeats;
          await tempFlight.update({numOfAvaGueField: newSeats});
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> increaseNumberOfSeats(
      String flightId, int numOfSeats, String flightClass) async {
    try {
      final tempFlight = flights.doc(flightId);
      final fetchedFlight = await tempFlight.get();

      if (flightClass == 'business') {
        int currentSeats = fetchedFlight.data()![numOfAvabusField];
        if (currentSeats > 0) {
          int newSeats = currentSeats + numOfSeats;
          tempFlight.update({numOfAvabusField: newSeats});
        }
      } else {
        int currentSeats = fetchedFlight.data()![numOfAvaGueField];
        if (currentSeats > 0) {
          int newSeats = currentSeats + numOfSeats;
          await tempFlight.update({numOfAvaGueField: newSeats});
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteRelatedTickets({required String bookingId}) async {
    try {
      final allTickets = await tickets
          .where(bookingReferenceField, isEqualTo: bookingId)
          .get();

      final List<QueryDocumentSnapshot> documents = allTickets.docs;

      for (QueryDocumentSnapshot document in documents) {
        await document.reference.delete();
      }
    } catch (e) {
      print('Error deleting tickets: $e');
    }
  }

  Future<double> updateRelatedTickets({
    required String bookingId,
    required String flightId,
    required double ticketPrice,
  }) async {
    double totalbookingPrice = 0;
    try {
      final allTickets = await tickets
          .where(bookingReferenceField, isEqualTo: bookingId)
          .where(flightRefField, isEqualTo: flightId)
          .get();

      final List<QueryDocumentSnapshot> documents = allTickets.docs;

      for (QueryDocumentSnapshot document in documents) {
        int numOfBaggage = document[bagQuantityField];

        double updatedTicketPrice =
            ticketPrice + (numOfBaggage.toDouble() * 251);

        totalbookingPrice = totalbookingPrice + updatedTicketPrice;

        await document.reference.update({
          ticketClassField: 'business',
          ticketPriceField: updatedTicketPrice,
        });
      }
    } catch (e) {
      print('Error updating tickets: $e');
    }
    return totalbookingPrice;
  }
}