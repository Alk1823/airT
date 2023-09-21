import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:AirTours/views/Round-Trip/available_return.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/firestore_flight.dart';

class RoundTripSearch1 extends StatefulWidget {
  final String from;
  final String to;
  final String flightClass;
  final int numOfPas;
  final DateTime depDate;
  final DateTime retDate;

  const RoundTripSearch1({
    super.key,
    required this.from,
    required this.to,
    required this.flightClass,
    required this.numOfPas,
    required this.depDate,
    required this.retDate,
  });

  @override
  State<RoundTripSearch1> createState() => _RoundTripSearch1State();
}

class _RoundTripSearch1State extends State<RoundTripSearch1> {
  late final FlightFirestore _flightsService;
  void toNext(CloudFlight flight1, double flightPrice1, String flightClass) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RoundTripSearch2(
                flight1: flight1,
                from: widget.to,
                flightPrice1: flightPrice1,
                to: widget.from,
                flightClass: flightClass,
                numOfPas: widget.numOfPas,
                depDate: widget.depDate,
                retDate: widget.retDate)));
  }

  @override
  void initState() {
    super.initState();
    _flightsService = FlightFirestore();
  }

  String calculateTravelTime(
    Timestamp departuredate,
    Timestamp arrivaldate,
    Timestamp departureTime,
    Timestamp arrivalTime,
  ) {
    DateTime departureDateTime = DateTime(
      departuredate.toDate().year,
      departuredate.toDate().month,
      departuredate.toDate().day,
      departureTime.toDate().hour,
      departureTime.toDate().minute,
    );

    DateTime arrivalDateTime = DateTime(
      arrivaldate.toDate().year,
      arrivaldate.toDate().month,
      arrivaldate.toDate().day,
      arrivalTime.toDate().hour,
      arrivalTime.toDate().minute,
    );

    Duration travelDuration = arrivalDateTime.difference(departureDateTime);
    int totalMinutes = travelDuration.inMinutes;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours < 0) {
      hours = hours * -1;
    }

    String formattedTravelTime = '${hours}h';

    if (minutes != 0) {
      formattedTravelTime += ' ${minutes}m';
    }

    return formattedTravelTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue[900],
            centerTitle: true,
            title: Text('${widget.from} to ${widget.to} ',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ))),
        body: SafeArea(
            child: StreamBuilder(
          stream: _flightsService.allFlights(
              from: widget.from,
              to: widget.to,
              flightClass: widget.flightClass,
              numOfPas: widget.numOfPas,
              date: widget.depDate),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final Iterable<CloudFlight> allFlights =
                      snapshot.data as Iterable<CloudFlight>;
                  return ListView.builder(
                    itemCount: allFlights.length,
                    itemBuilder: (context, index) {
                      final Iterable<CloudFlight> sortedFlights =
                          _flightsService.sortFlightsByDuration(allFlights);

                      final flight = sortedFlights.elementAt(index);
                      double flightText = widget.flightClass == 'business'
                          ? flight.busPrice
                          : flight.guestPrice;
                      DateTime flightDate = flight.depDate.toDate();
                      DateTime flightTime = flight.depTime.toDate();
                      DateTime totalFlightTime = DateTime(
                          flightDate.year,
                          flightDate.month,
                          flightDate.day,
                          flightTime.hour,
                          flightTime.minute);

                      if (DateTime.now().isBefore(totalFlightTime)) {
                        return GestureDetector(
                          onTap: () {
                            toNext(flight, flightText, widget.flightClass);
                          },
                          child: Container(
                              //width: double.infinity,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 2, offset: Offset(0, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(flight.fromCity),
                                        Container(
                                          height: 40,
                                          child: Image.asset(
                                              'images/flightFromTo.jpg'),
                                        ),
                                        Text(flight.toCity),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          //MainAxisAlignment.spaceEvenly,
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _flightsService
                                              .formatTime(flight.depTime),
                                        ),
                                        Text(calculateTravelTime(
                                            flight.depDate,
                                            flight.arrDate,
                                            flight.depTime,
                                            flight.arrTime)),
                                        Text(
                                          _flightsService
                                              .formatTime(flight.arrTime),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height: 1.0,
                                      color: Colors.black,
                                      width: double.infinity,
                                      //child: SizedBox.expand(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Price",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                        Text(
                                          "$flightText SAR",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }

              default:
                return const CircularProgressIndicator();
            }
          },
        )));
  }
}
