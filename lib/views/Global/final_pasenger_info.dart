import 'package:AirTours/views/Global/paymentPage.dart';
import 'package:AirTours/views/Global/ticket.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:AirTours/views/Global/global_var.dart';

import '../../services/cloud/cloud_booking.dart';

class Enterinfo extends StatefulWidget {
  final String id1;
  final String id2;
  final double flightPrice1;
  final double flightPrice2;
  final String flightClass;
  const Enterinfo(
      {super.key,
      required this.id1,
      required this.id2,
      required this.flightPrice1,
      required this.flightPrice2,
      required this.flightClass});

  @override
  State<Enterinfo> createState() => _EnterinfoState();
}

class _EnterinfoState extends State<Enterinfo> {
  List<Ticket> tickets = [];
  Ticket? temp1;
  Ticket? temp2;
  double? totalTicketPrice;
  final formKey = GlobalKey<FormState>();
  String free = "Free";
  String selectedMeal = "Default Meal";
  List<String> mealList = [
    "Default Meal",
    "Law calorie meal",
    "No salt meal",
    "Asian Vegetarian Meal",
    "Western Vegetarian Meal",
    "Low Salt Meal",
    "Low fat Meal",
    "Lacto-ovo Vegetarian Meal",
    "Gluten Free Meal",
  ];
  String _selectedTitle = "Mr";
  final List<String> _titles = [
    "Mr",
    "Ms",
  ];
  int pasCount = 1;
  int visualPasCount = 1;
  TextEditingController fName = TextEditingController();
  TextEditingController mName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController ssn = TextEditingController();
  DateTime dateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String? valueFirstName;
  String? valueLastName;
  String? valueMidleName;
  int? ssn1;
  DateTime? birthD;

  CloudBooking? booking;

  @override
  void initState() {
    super.initState();

    birthD = dateTime;
  }

  void toNext(List<Ticket> alltickets) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Payment(
                paymentFor: 'booking',
                id1: widget.id1,
                id2: widget.id2,
                flightClass: widget.flightClass,
                tickets: alltickets)));
  }

  void icreaseBaggageCount() {
    setState(() {
      if (baggageCount == 3) return;
      baggagePrice += 251;
      baggageCount++;
    });
  }

  void decreaseBaggageCount() {
    setState(() {
      if (baggageCount == 1) {
        free = "Free";
        return;
      }
      baggagePrice -= 251;
      baggageCount--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Info'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " Adult $visualPasCount",
                  style: const TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownButtonFormField<String>(
                              value: _selectedTitle,
                              items: _titles.map((String title) {
                                return DropdownMenuItem<String>(
                                  value: title,
                                  child: Text(
                                    title,
                                    style: const TextStyle(),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedTitle = newValue!;
                                });
                              },
                              decoration: const InputDecoration(
                                border:
                                    InputBorder.none, // sets the border to none
                                hintText: 'Select an option',
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      flex: 3,
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
                              controller: fName,
                              decoration: const InputDecoration(
                                labelText: "First name",
                                //hintText: "First name",
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
                    ),
                  ],
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
                        controller: mName,
                        decoration: const InputDecoration(
                          labelText: "Middle name",
                          //hintText: "Midle name",
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "You did not enter your middle name";
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return 'Please enter a valid name';
                          }
                          return null;
                        },
                      ),
                    )),
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
                        controller: lName,
                        decoration: const InputDecoration(
                          labelText: "Last name",
                          //hintText: "Last name",
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "You did not enter your last name";
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return 'Please enter a valid name';
                          }
                          return null;
                          //return null;
                        },
                      ),
                    )),
                Row(
                  children: [
                    Expanded(
                      //flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
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
                                controller: ssn,
                                decoration: const InputDecoration(
                                  labelText: " SSN",
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your ID number';
                                  }
                                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                    return 'Please enter a valid ID number (10 digits)';
                                  }
                                  int sum = 0;
                                  for (int i = 0; i < 9; i++) {
                                    int digit = int.parse(value[i]);
                                    if (i % 2 == 0) {
                                      digit *= 2;
                                      if (digit > 9) {
                                        digit -= 9;
                                      }
                                    }
                                    sum += digit;
                                  }
                                  //لاتنسى تشيل الكومنت
                                  // int checkDigit = (sum * 9) % 10;
                                  // if (checkDigit != int.parse(value[9])) {
                                  //   return 'Invalid ID number';
                                  // }
                                  return null;
                                },
                              ),
                            )),
                      ),
                    ),
                    Expanded(
                      //flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: TextButton(
                                child: Text(
                                  "${monthNames[dateTime.month - 1]} ${dateTime.day} ${dateTime.year}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 17),
                                ),
                                onPressed: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Done")),
                                              Expanded(
                                                  child: CupertinoDatePicker(
                                                initialDateTime: dateTime,
                                                maximumDate: dateTime,
                                                mode: CupertinoDatePickerMode
                                                    .date,
                                                onDateTimeChanged: (data) {
                                                  setState(() {
                                                    dateTime = data;
                                                  });
                                                },
                                              ))
                                            ],
                                          ),
                                        );
                                      });
                                })),
                      ),
                    ),
                  ],
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
                      padding: const EdgeInsets.all(10.0),
                      child: DropdownButtonFormField<String>(
                        value: selectedMeal,
                        items: mealList.map((String title) {
                          return DropdownMenuItem<String>(
                            value: title,
                            child: Text(
                              title,
                              style: const TextStyle(),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedMeal = newValue!;
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none, // sets the border to none
                          hintText: 'Select an option',
                        ),
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.all(5),
                    width: double.infinity,
                    //padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Baggage"),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: decreaseBaggageCount,
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                      size: 15,
                                    )),
                                Text("$baggageCount x 23Kg"),
                                TextButton(
                                    onPressed: icreaseBaggageCount,
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 15,
                                    )),
                              ],
                            ),
                            Text(
                                baggageCount == 1 ? free : "${baggagePrice}SR"),
                            //Text("${baggageCount == 1 ? free : baggagePrice}"),
                          ],
                        ))),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (formKey.currentState!.validate()) {
                        for (pasCount; pasCount < count;) {
                          pasCount++;
                          visualPasCount++;

                          totalTicketPrice = widget.flightPrice1 + baggagePrice;
                          temp1 = Ticket(
                            firstName: fName.text,
                            middleName: mName.text,
                            checkInStatus: false,
                            bagQuantity: baggageCount,
                            mealType: selectedMeal,
                            lastName: lName.text,
                            ticketPrice: totalTicketPrice!,
                            birthDate: dateTime,
                            flightReference: widget.id1,
                            ticketClass: widget.flightClass,
                            ticketUserId: '1',
                          );
                          tickets.add(temp1!);

                          if (widget.id2 != 'none') {
                            totalTicketPrice =
                                widget.flightPrice2 + baggagePrice;
                            temp2 = Ticket(
                              firstName: fName.text,
                              middleName: mName.text,
                              checkInStatus: false,
                              bagQuantity: baggageCount,
                              mealType: selectedMeal,
                              lastName: lName.text,
                              ticketPrice: totalTicketPrice!,
                              birthDate: dateTime,
                              flightReference: widget.id2,
                              ticketClass: widget.flightClass,
                              ticketUserId: '1',
                            );
                            tickets.add(temp2!);
                          }
                          fName.clear();
                          mName.clear();
                          lName.clear();
                          ssn.clear();

                          baggagePrice = 0;
                          baggageCount = 1;
                          selectedMeal = mealList[0];
                          dateTime = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          );

                          return;
                        }

                        if (pasCount == count) {
                          totalTicketPrice = widget.flightPrice1 + baggagePrice;
                          temp1 = Ticket(
                            firstName: fName.text,
                            middleName: mName.text,
                            checkInStatus: false,
                            bagQuantity: baggageCount,
                            mealType: selectedMeal,
                            lastName: lName.text,
                            ticketPrice: totalTicketPrice!,
                            birthDate: dateTime,
                            flightReference: widget.id1,
                            ticketClass: widget.flightClass,
                            ticketUserId: '1',
                          );
                          tickets.add(temp1!);

                          if (widget.id2 != 'none') {
                            totalTicketPrice =
                                widget.flightPrice2 + baggagePrice;
                            temp2 = Ticket(
                              firstName: fName.text,
                              middleName: mName.text,
                              checkInStatus: false,
                              bagQuantity: baggageCount,
                              mealType: selectedMeal,
                              lastName: lName.text,
                              ticketPrice: totalTicketPrice!,
                              birthDate: dateTime,
                              flightReference: widget.id2,
                              ticketClass: widget.flightClass,
                              ticketUserId: '1',
                            );
                            tickets.add(temp2!);
                          }

                          print('$pasCount ok?');
                          toNext(tickets);
                          pasCount++;
                        }
                        if (pasCount > count) {
                          totalTicketPrice = widget.flightPrice1 + baggagePrice;
                          temp1 = Ticket(
                            firstName: fName.text,
                            middleName: mName.text,
                            checkInStatus: false,
                            bagQuantity: baggageCount,
                            mealType: selectedMeal,
                            lastName: lName.text,
                            ticketPrice: totalTicketPrice!,
                            birthDate: dateTime,
                            flightReference: widget.id1,
                            ticketClass: widget.flightClass,
                            ticketUserId: '1',
                          );
                          if (widget.id2 == 'none') {
                            tickets[tickets.length - 1] = temp1!;
                          } else {
                            tickets[tickets.length - 2] = temp1!;
                          }

                          if (widget.id2 != 'none') {
                            totalTicketPrice =
                                widget.flightPrice2 + baggagePrice;
                            temp2 = Ticket(
                              firstName: fName.text,
                              middleName: mName.text,
                              checkInStatus: false,
                              bagQuantity: baggageCount,
                              mealType: selectedMeal,
                              lastName: lName.text,
                              ticketPrice: totalTicketPrice!,
                              birthDate: dateTime,
                              flightReference: widget.id2,
                              ticketClass: widget.flightClass,
                              ticketUserId: '1',
                            );
                            tickets[tickets.length - 1] = temp2!;
                          }
                          toNext(tickets);
                        }
                      }
                    });
                    double totPrice = 0;
                    for (final x in tickets) {
                      totPrice = totPrice + x.ticketPrice;
                    }
                    price = totPrice; //price in global var
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(blurRadius: 2, offset: Offset(0, 0)),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        pasCount >= count ? "Confirm" : "Next Passenger",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}