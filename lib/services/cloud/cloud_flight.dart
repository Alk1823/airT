import 'package:AirTours/constants/flight_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFlight {
  final String documentId;
  final String fromCity;
  final String toCity;
  final String fromAirport;
  final String toAirport;
  final Timestamp depDate;
  final Timestamp arrDate;
  final Timestamp arrTime;
  final Timestamp depTime;
  final int numOfBusiness;
  final int numOfGuest;
  final double guestPrice;
  final double busPrice;
  final int numOfAvaBusiness;
  final int numOfAvaGuest;

  CloudFlight({
    required this.documentId,
    required this.fromCity,
    required this.toCity,
    required this.fromAirport,
    required this.toAirport,
    required this.numOfBusiness,
    required this.numOfGuest,
    required this.guestPrice,
    required this.busPrice,
    required this.depDate,
    required this.arrDate,
    required this.arrTime,
    required this.depTime,
    required this.numOfAvaBusiness,
    required this.numOfAvaGuest,
  });

  CloudFlight.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        fromCity = snapshot.data()[fromField] as String,
        toCity = snapshot.data()[toField] as String,
        fromAirport = snapshot.data()[fromAirField] as String,
        toAirport = snapshot.data()[toAirField] as String,
        guestPrice = snapshot.data()[guePriceField] as double,
        busPrice = snapshot.data()[busPriceField] as double,
        numOfBusiness = snapshot.data()[numOfbusField] as int,
        numOfGuest = snapshot.data()[numOfGueField] as int,
        numOfAvaBusiness = snapshot.data()[numOfAvabusField] as int,
        numOfAvaGuest = snapshot.data()[numOfAvaGueField] as int,
        depDate = snapshot.data()[depDateField] as Timestamp,
        arrDate = snapshot.data()[arrDateField] as Timestamp,
        arrTime = snapshot.data()[arrTimeField] as Timestamp,
        depTime = snapshot.data()[depTimeField] as Timestamp;
}
