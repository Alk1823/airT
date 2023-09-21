import 'package:AirTours/services/cloud/cloud_booking.dart';
import 'package:AirTours/services/cloud/cloud_flight.dart';
import 'package:AirTours/services/cloud/cloud_ticket.dart';
import 'package:AirTours/services/cloud/firestore_ticket.dart';
import 'package:AirTours/utilities/show_error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Global/global_var.dart';
import 'boarding_pass.dart';

class TicketsView extends StatefulWidget {
  final CloudBooking booking;
  final CloudFlight flight;

  const TicketsView({
    Key? key,
    required this.booking,
    required this.flight,
  }) : super(key: key);

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  late final TicketFirestore _ticketsService;
  late final String bookingId;
  late final String flightId;

  @override
  void initState() {
    super.initState();
    _ticketsService = TicketFirestore();
    flightId = widget.flight.documentId;
    bookingId = widget.booking.documentId;
  }

  String date1(Timestamp date) {
    DateTime departureDate = date.toDate();
    DateFormat formatter = DateFormat('MM dd yyyy');
    String formattedDate = formatter.format(departureDate);
    List<String> parts = formattedDate.split(' ');
    int month = int.parse(parts[0]);
    String monthName = monthNames[month - 1];
    String day = parts[1];
    String year = parts[2];
    return '$monthName $day $year';
  }

  String date2(Timestamp date) {
    DateTime departureDate = date.toDate();
    DateFormat formatter = DateFormat('MM dd yyyy');
    String formattedDate = formatter.format(departureDate);
    List<String> parts = formattedDate.split(' ');
    int month = int.parse(parts[0]);
    int monthName = month;
    String day = parts[1];
    String year = parts[2];
    return '$day/$monthName/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'List of Tickets',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<Iterable<CloudTicket>>(
          stream: _ticketsService.allTickets(
              bookingId: bookingId, flightId: flightId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final allTickets = snapshot.data!;
              return ListView.builder(
                itemCount: allTickets.length,
                itemBuilder: (context, index) {
                  final ticket = allTickets.elementAt(index);
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Ticket:",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text("Booking Reference:",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ticket.documentId),
                                  Text(widget.booking.documentId)
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 1.0,
                                color: Colors.black,
                                width: double.infinity,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Name:",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text("Birth Date:",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${ticket.firstName} ${ticket.middleName} ${ticket.lastName}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(date2(ticket.birthDate))
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Meal Type:",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      )),
                                  Row(
                                    children: [
                                      Text("Baggage quantity:",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          )),
                                      //Text("${ticket.bagQuantity}")
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ticket.mealType),
                                  Text("${ticket.bagQuantity}")
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Ticket Price: ",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      )),
                                  Text(
                                    "${ticket.ticketPrice}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (ticket.checkInStatus == false) {
                              final bool isChecked = await _ticketsService
                                  .checkInUpdating(ticket.documentId, flightId);
                              print(isChecked);
                              if (isChecked == true) {
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BoardingPass(
                                          booking: widget.booking,
                                          flight: widget.flight,
                                          ticket: ticket),
                                    ));
                              } else {
                                showErrorDialog(context,
                                    "You can't check-in now. Check-in for your flight would be available within 24 hours of departure. ");
                              }
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BoardingPass(
                                        booking: widget.booking,
                                        flight: widget.flight,
                                        ticket: ticket),
                                  ));
                            }
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      ticket.checkInStatus
                                          ? 'View Boarding Pass'
                                          : 'Issue Boarding Pass',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}