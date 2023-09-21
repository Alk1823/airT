import 'package:AirTours/services_auth/auth_service.dart';
import 'package:AirTours/utilities/show_balance.dart';
import 'package:AirTours/utilities/show_feedback.dart';
import 'package:AirTours/views/Global/global_var.dart';
import 'package:AirTours/views/Global/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/pages_route.dart';
import '../../services/cloud/cloud_booking.dart';
import '../../services/cloud/firestore_booking.dart';
import '../../services/cloud/firestore_ticket.dart';
import '../../utilities/show_error.dart';





class Creditcard extends StatefulWidget {
  final String id1;
  final String paymentFor;
  final String id2;
  final String flightClass;
  final List<Ticket> tickets;
  const Creditcard(
      {super.key,
      required this.id1,
      required this.id2,
      required this.flightClass,
      required this.tickets,
      required this.paymentFor});

  @override
  State<Creditcard> createState() => _CreditcardState();
}

class _CreditcardState extends State<Creditcard> {
  final user = FirebaseFirestore.instance.collection('user'); 
  final formKey = GlobalKey<FormState>();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardName = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController expiryDate = TextEditingController();
  late final TicketFirestore _ticketService;
  late final BookingFirestore _bookingService;
  CloudBooking? booking;
  bool isSucess = false;
  //late double price;
 
  

  @override
  void initState() {
    super.initState();
    _bookingService = BookingFirestore();
    _ticketService = TicketFirestore();
    //price = retrieveTotBookingsPrice();
  }

  Future<String> createBooking(double totalPrice) async {
    final bookingUserId = AuthService.firebase().currentUser!.id;
    DateTime timeNow = DateTime.now();
    if (widget.id2 == 'none') {
      booking = await _bookingService.createNewBooking(
          bookingClass: widget.flightClass,
          bookingPrice: totalPrice,
          departureFlight: widget.id1,
          returnFlight: 'none',
          numOfSeats: count,
          bookingUserId: bookingUserId,
          bookingTime: timeNow);
      final bookingRef = booking!.documentId;
      return bookingRef;
    } else {
      booking = await _bookingService.createNewBooking(
          bookingClass: widget.flightClass,
          bookingPrice: totalPrice,
          departureFlight: widget.id1,
          returnFlight: widget.id2,
          numOfSeats: count,
          bookingUserId: bookingUserId,
          bookingTime: timeNow);
      final bookingRef = booking!.documentId;
      return bookingRef;
    }
  }

  

  void toNext(List<Ticket> alltickets) async {
    double totalBookingPrice = 0;
    for (var x in alltickets) {
      totalBookingPrice = totalBookingPrice + x.ticketPrice;
    }

    final tmp = await createBooking(totalBookingPrice);

    alltickets.forEach((ticket) async {
      await _ticketService.createNewTicket(
          firstName: ticket.firstName,
          middleName: ticket.middleName,
          checkInStatus: ticket.checkInStatus,
          bagQuantity: ticket.bagQuantity,
          mealType: ticket.mealType,
          lastName: ticket.lastName,
          ticketPrice: ticket.ticketPrice,
          bookingReference: tmp,
          ticketUserId: '1',
          birthDate: ticket.birthDate,
          flightReference: ticket.flightReference,
          ticketClass: widget.flightClass);
    });
    //await showFeedback(context, 'Booking sucessfully created.'); causes error
  }

  
  //  double retrieveTotBookingsPrice() {
  //     double totBookingPrice = 0;
  //     for (final x in widget.tickets) {
  //       totBookingPrice = totBookingPrice + x.ticketPrice;
  //     }
  //     return totBookingPrice;
  // }

  bool isUnderage(DateTime dateOfBirth) {
  final currentDate = DateTime.now();
  int age = currentDate.year - dateOfBirth.year;

  if (currentDate.month < dateOfBirth.month) {
    age--;
  } else if (currentDate.month == dateOfBirth.month) {
    if (currentDate.day < dateOfBirth.day) {
      age--;
    }
  }
  return age < 18;
}

  void discountChildren() {
    double temp;
    for (final x in widget.tickets) {
      if (isUnderage(x.birthDate)) {
        temp = 0;
        temp = x.ticketPrice * 0.05;
        price = price - temp;
      } 
    }
  }
 

  double showTotBookingPrice() {
    discountChildren();
    return price;
  }

  Future<void> discountBookingPrice() async {
      
    //balance
    double balance = await showUserBalance(); 

    String userId = AuthService.firebase().currentUser!.id;

    final docR = user.doc(userId); //user doc
    if (price <= balance) {
      if (price == 0.0) {
        await showErrorDialog(context, "Can't Discount More, Your Booking Price is already 0");
      }
      else {
          final newBalance = balance - price;
          price = 0.0;
        await docR.update({
          'balance': newBalance
        });
      }
    } else {
      if (balance == 0.0) {
        await showErrorDialog(context, 'No Balance Available!');
      } else {
          final newPrice = price - balance;
          price = newPrice;
          await docR.update({
            'balance': 0.0
         });
      }
      
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text('Booking Price: ${showTotBookingPrice()}',style: const TextStyle(fontSize: 16),),
                    const SizedBox(width: 10,),
                    FutureBuilder<double>(
                      future: showUserBalance(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Text("Your Balance: ${snapshot.data!}",style: const TextStyle(fontSize: 16),);
                        } else {
                          return const Text('No Data Available');
                        }
                      },
                    )
                ],
              ),
            ),
              
          ],
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                            CardNumber(),
                          ],
                          controller: cardNumber,
                          decoration: const InputDecoration(
                            labelText: "Card Number",
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter a card number";
                            }
                            // if (!RegExp(r'^\d{19}$').hasMatch(value)) {
                            //   return "Enter a valid card number aziz";
                            // }
                            if (value.length != 22) {
                              return "Enter a valid card number";
                            }
                            return null;
                          },
                        ),
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          controller: cardName,
                          decoration: const InputDecoration(
                            labelText: "Name",
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "You did not enter your first name";
                            }
                            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                              return 'Please enter a valid name';
                            }
                            return null;
                          },
                        ),
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                controller: cvv,
                                decoration: const InputDecoration(
                                  labelText: "CVV",
                                  hintText: "Enter the 3 digit number",
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter enter a CVV";
                                  }
                                  return null;
                                },
                              ),
                            )),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                  CardExpiry(),
                                ],
                                controller: expiryDate,
                                decoration: const InputDecoration(
                                  labelText: "Expiry date",
                                  hintText: "MM/YY",
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter an Expiry Date";
                                  }

                                  List<String> parts = value.split('/');
                                  if (parts.length != 2) {
                                    return "Enter a valid Expiry Date";
                                  }

                                  int? month = int.tryParse(parts[0]);
                                  int? year = int.tryParse(parts[1]);

                                  if (month == null || year == null) {
                                    return "Enter a valid Expiry Date";
                                  }

                                  if (month > 12 && year < 23) {
                                    return "Enter the Expiry Date correctly";
                                  }
                                  if (month > 12) {
                                    return "Enter the month correctly";
                                  }
                                  if (year < 23) {
                                    return "Enter the year correctly";
                                  }
                                  return null;
                                },
                              ),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 2, offset: Offset(0, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue),
                              child: const Center(
                                  child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ))),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (formKey.currentState!.validate()) {
                                if (widget.paymentFor == 'booking') {
                                  toNext(widget.tickets);

                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      bottomRoute, (route) => false);
                                } else if (widget.paymentFor == "upgrade") {
                                  isSucess = true;
                                  Navigator.pop(context, isSucess);
                                }
                              }
                            });
                          },
                          child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 2, offset: Offset(0, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue),
                              child: const Center(
                                  child: Text(
                                "Confirm Payment",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ))),
                        ),
                      )
                    ],
                  ),
                 GestureDetector(
                          onTap: () async {
                            await discountBookingPrice();
                            setState(() {});
                          },
                          child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 2, offset: Offset(0, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue),
                              child: const Center(
                                  child: Text(
                                "Discount Using Balance",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ))),
                        ),
                ],
              ),
            ),
          ),
        )));
  }
}

class CardNumber extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;
      if (index % 4 == 0 && inputData.length != index) {
        buffer.write("  ");
      }
    }
    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}

class CardExpiry extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (var i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var index = i + 1;
      if (index % 2 == 0 && index != newText.length) {
        buffer.write("/");
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}