import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:AirTours/constants/flight_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FlightFirestore {
  final flights = FirebaseFirestore.instance.collection('flights');

  static final FlightFirestore _shared = FlightFirestore._sharedInstance();
  FlightFirestore._sharedInstance();
  factory FlightFirestore() => _shared;

  Stream<Iterable<CloudFlight>> allFlights({
    required String from,
    required String to,
    required String flightClass,
    required int numOfPas,
    required DateTime date,
  }) {
    Timestamp depDateStamp = Timestamp.fromDate(date);

    if (flightClass == 'business') {
      final allFlights = flights
          .where(fromField, isEqualTo: from)
          .where(toField, isEqualTo: to)
          .where(numOfAvabusField, isGreaterThanOrEqualTo: numOfPas)
          .where(depDateField, isEqualTo: depDateStamp)
          .snapshots()
          .map((event) =>
              event.docs.map((doc) => CloudFlight.fromSnapshot(doc)));

      return allFlights;
    } else {
      final allFlights = flights
          .where(fromField, isEqualTo: from)
          .where(toField, isEqualTo: to)
          .where(numOfAvaGueField, isGreaterThanOrEqualTo: numOfPas)
          .where(depDateField, isEqualTo: depDateStamp)
          .snapshots()
          .map((event) =>
              event.docs.map((doc) => CloudFlight.fromSnapshot(doc)));
      return allFlights;
    }
  }

  Future<CloudFlight> createNewFlight({
    required fromCity,
    required toCity,
    required fromAirport,
    required toAirport,
    required numOfBusiness,
    required numOfGuest,
    required guestPrice,
    required busPrice,
    required depDate,
    required arrDate,
    required arrTime,
    required depTime,
  }) async {
    final document = await flights.add({
      fromField: fromCity,
      toField: toCity,
      fromAirField: fromAirport,
      toAirField: toAirport,
      numOfbusField: numOfBusiness,
      numOfGueField: numOfGuest,
      guePriceField: guestPrice,
      busPriceField: busPrice,
      depDateField: depDate,
      arrDateField: arrDate,
      arrTimeField: arrTime,
      depTimeField: depTime,
      numOfAvabusField: numOfBusiness,
      numOfAvaGueField: numOfGuest,
    });
    final fetchedFlight = await document.get();
    return CloudFlight(
        documentId: fetchedFlight.id,
        fromCity: fromCity,
        toCity: toCity,
        fromAirport: fromAirport,
        toAirport: toAirport,
        numOfBusiness: numOfBusiness,
        numOfGuest: numOfGuest,
        guestPrice: guestPrice,
        busPrice: busPrice,
        depDate: depDate,
        arrDate: arrDate,
        arrTime: arrTime,
        depTime: depTime,
        numOfAvaBusiness: numOfBusiness,
        numOfAvaGuest: numOfBusiness);
  }

  String formatTime(Timestamp timestamp) {
    var date = timestamp.toDate();
    var format = DateFormat('h:mm a');
    return format.format(date);
  }

  Future<List<CloudFlight>> getFlights(
      String departureId, String returnId) async {
    List<CloudFlight> currFlights = [];

    final tempdepFlight = flights.doc(departureId);
    final fetchedFlight = await tempdepFlight.get();
    final depFlight = CloudFlight(
        documentId: fetchedFlight.id,
        fromCity: fetchedFlight.data()![fromField],
        toCity: fetchedFlight.data()![toField],
        fromAirport: fetchedFlight.data()![fromAirField],
        toAirport: fetchedFlight.data()![toAirField],
        numOfBusiness: fetchedFlight.data()![numOfbusField],
        numOfGuest: fetchedFlight.data()![numOfGueField],
        guestPrice: fetchedFlight.data()![guePriceField],
        busPrice: fetchedFlight.data()![busPriceField],
        depDate: fetchedFlight.data()![depDateField],
        arrDate: fetchedFlight.data()![arrDateField],
        arrTime: fetchedFlight.data()![arrTimeField],
        depTime: fetchedFlight.data()![depTimeField],
        numOfAvaBusiness: fetchedFlight.data()![numOfAvabusField],
        numOfAvaGuest: fetchedFlight.data()![numOfAvaGueField]);
    currFlights.add(depFlight);

    if (returnId != 'none') {
      final tempFlight = flights.doc(returnId);
      final fetchedFlight = await tempFlight.get();
      final retFlight = CloudFlight(
          documentId: fetchedFlight.id,
          fromCity: fetchedFlight.data()![fromField],
          toCity: fetchedFlight.data()![toField],
          fromAirport: fetchedFlight.data()![fromAirField],
          toAirport: fetchedFlight.data()![toAirField],
          numOfBusiness: fetchedFlight.data()![numOfbusField],
          numOfGuest: fetchedFlight.data()![numOfGueField],
          guestPrice: fetchedFlight.data()![guePriceField],
          busPrice: fetchedFlight.data()![busPriceField],
          depDate: fetchedFlight.data()![depDateField],
          arrDate: fetchedFlight.data()![arrDateField],
          arrTime: fetchedFlight.data()![arrTimeField],
          depTime: fetchedFlight.data()![depTimeField],
          numOfAvaBusiness: fetchedFlight.data()![numOfAvabusField],
          numOfAvaGuest: fetchedFlight.data()![numOfAvaGueField]);
      currFlights.add(retFlight);
    }
    return currFlights;
  }

  Future<bool> isCurrentFlight(String departureId, String returnId) async {
    if (returnId != 'none') {
      final tempFlight = flights.doc(returnId);
      final fetchedFlight = await tempFlight.get();

      if (fetchedFlight.exists) {
        DateTime flightDate = fetchedFlight.data()![arrDateField].toDate();
        DateTime flightTime = fetchedFlight.data()![arrTimeField].toDate();
        DateTime totalTime = DateTime(flightDate.year, flightDate.month,
            flightDate.day, flightTime.hour, flightTime.minute);

        if (totalTime.isAfter(DateTime.now())) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else if (returnId == 'none') {
      final tempFlight = flights.doc(departureId);
      final fetchedFlight = await tempFlight.get();

      if (fetchedFlight.exists) {
        DateTime flightDate = fetchedFlight.data()![arrDateField].toDate();
        DateTime flightTime = fetchedFlight.data()![arrTimeField].toDate();
        DateTime totalTime = DateTime(flightDate.year, flightDate.month,
            flightDate.day, flightTime.hour, flightTime.minute);
        if (totalTime.isAfter(DateTime.now())) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Iterable<CloudFlight> sortFlightsByDuration(Iterable<CloudFlight> flights) {
    List<CloudFlight> sortedFlights = flights.toList();
    int length = sortedFlights.length;

    for (int i = 0; i < length - 1; i++) {
      for (int j = 0; j < length - i - 1; j++) {
        DateTime flightDate1 = sortedFlights[j].depDate.toDate();
        DateTime flightTime1 = sortedFlights[j].depTime.toDate();
        DateTime totalDepTime1 = DateTime(
          flightDate1.year,
          flightDate1.month,
          flightDate1.day,
          flightTime1.hour,
          flightTime1.minute,
        );

        DateTime flightArr1 = sortedFlights[j].arrDate.toDate();
        DateTime flightArrTime1 = sortedFlights[j].arrTime.toDate();
        DateTime totalArrTime1 = DateTime(
          flightArr1.year,
          flightArr1.month,
          flightArr1.day,
          flightArrTime1.hour,
          flightArrTime1.minute,
        );

        DateTime flightDate2 = sortedFlights[j + 1].depDate.toDate();
        DateTime flightTime2 = sortedFlights[j + 1].depTime.toDate();
        DateTime totalDepTime2 = DateTime(
          flightDate2.year,
          flightDate2.month,
          flightDate2.day,
          flightTime2.hour,
          flightTime2.minute,
        );

        DateTime flightArr2 = sortedFlights[j + 1].arrDate.toDate();
        DateTime flightArrTime2 = sortedFlights[j + 1].arrTime.toDate();
        DateTime totalArrTime2 = DateTime(
          flightArr2.year,
          flightArr2.month,
          flightArr2.day,
          flightArrTime2.hour,
          flightArrTime2.minute,
        );

        Duration durationA = totalArrTime1.difference(totalDepTime1);
        Duration durationB = totalArrTime2.difference(totalDepTime2);

        if (durationA.compareTo(durationB) > 0) {
          CloudFlight temp = sortedFlights[j];
          sortedFlights[j] = sortedFlights[j + 1];
          sortedFlights[j + 1] = temp;
        }
      }
    }

    return sortedFlights;
  }

  Future<bool> didFly({required departureFlightId}) async {
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
          flag = true;
        }
        return flag;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}