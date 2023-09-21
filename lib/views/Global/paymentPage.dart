import 'package:AirTours/views/Global/ticket.dart';
import 'package:flutter/material.dart';

import 'credit_card.dart';

class Payment extends StatefulWidget {
  final String id1;
  final String id2;
  final String flightClass;
  final String paymentFor;
  final List<Ticket> tickets;
  const Payment(
      {super.key,
      required this.id1,
      required this.id2,
      required this.flightClass,
      required this.tickets,
      required this.paymentFor});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "How do you want to pay",
            ),
            GestureDetector(
              onTap: () async {
                bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Creditcard(
                            paymentFor: widget.paymentFor,
                            id1: widget.id1,
                            id2: widget.id2,
                            flightClass: widget.flightClass,
                            tickets: widget.tickets))); //Creditcard

                if (widget.paymentFor == 'upgrade') {
                  Navigator.pop(context, result);
                }
              },
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: const Text(
                    "Credit/Debit card",
                    style: TextStyle(fontSize: 15),
                  )),
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Criditcard()));
              },
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: const Text(
                    "Wallet",
                    style: TextStyle(fontSize: 15),
                  )),
            )
          ],
        ),
      )),
    );
  }
}