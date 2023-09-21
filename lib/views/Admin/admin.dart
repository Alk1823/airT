// ignore_for_file: use_build_context_synchronously

import 'package:AirTours/constants/pages_route.dart';
import 'package:AirTours/utilities/show_feedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/cloud/cloud_flight.dart';
import '../../services/cloud/firestore_flight.dart';
import '../../services_auth/auth_service.dart';
import '../../utilities/show_error.dart';

class CreateFlight extends StatefulWidget {
  const CreateFlight({super.key});

  @override
  State<CreateFlight> createState() => _CreateFlightState();
}

class _CreateFlightState extends State<CreateFlight> {
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  TextEditingController fromAir = TextEditingController();
  TextEditingController toAir = TextEditingController();
  TextEditingController numOfGuest = TextEditingController();
  TextEditingController numOfBusiness = TextEditingController();
  TextEditingController guestPrice = TextEditingController();
  TextEditingController businessPrice = TextEditingController();
  TextEditingController depDate = TextEditingController();
  TextEditingController arrDate = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController depTime = TextEditingController();
  TextEditingController arrTime = TextEditingController();
  late DateTime? selectedDepDate;
  late DateTime? selectedArrDate;
  late TimeOfDay selectedDepTime;
  late TimeOfDay selectedArrTime;
  CloudFlight? _flight;
  late final FlightFirestore _flightsService;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _flightsService = FlightFirestore();
  }

  void clearAllFields() {
    from.clear();
    to.clear();
    fromAir.clear();
    toAir.clear();
    numOfGuest.clear();
    numOfBusiness.clear();
    guestPrice.clear();
    businessPrice.clear();
    depDate.clear();
    arrDate.clear();
    time.clear();
    depTime.clear();
    arrTime.clear();
  }

  Future<CloudFlight> createFlight({
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
    Timestamp depDateStamp = Timestamp.fromDate(depDate);
    Timestamp arrDateStamp = Timestamp.fromDate(arrDate);
    Timestamp depTimeStamp = Timestamp.fromDate(depTime);
    Timestamp arrTimeStamp = Timestamp.fromDate(arrTime);
    int intNumOfBus = int.parse(numOfBusiness);
    int intNumOfGuest = int.parse(numOfGuest);
    double guePrice = double.parse(guestPrice);
    double businessPrice = double.parse(busPrice);

    final newFlight = await _flightsService.createNewFlight(
      fromCity: fromCity,
      toCity: toCity,
      fromAirport: fromAirport,
      toAirport: toAirport,
      numOfBusiness: intNumOfBus,
      numOfGuest: intNumOfGuest,
      guestPrice: guePrice,
      busPrice: businessPrice,
      depDate: depDateStamp,
      arrDate: arrDateStamp,
      arrTime: arrTimeStamp,
      depTime: depTimeStamp,
    );

    _flight = newFlight;
    return newFlight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          "Admin",
          textAlign: TextAlign.center,
        )),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(5),
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(blurRadius: 2, offset: Offset(0, 0))
              ], borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        }

                                        if (!RegExp(r'^[a-z A-Z]+$')
                                            .hasMatch(value)) {
                                          return 'Please Enter a city';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: from,
                                      keyboardType: TextInputType.text,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        icon:
                                            Icon(Icons.flight_takeoff_rounded),
                                        hintText: "From",
                                      ))),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        }

                                        if (!RegExp(r'^[a-z A-Z]+$')
                                            .hasMatch(value)) {
                                          return 'Please Enter a city';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: to,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.flight_land),
                                        hintText: "To",
                                      )))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required Field";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: depDate,
                                readOnly: true,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.calendar_month),
                                  hintText: "Departure Date",
                                ),
                                onTap: () async {
                                  DateTime? temp = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  );

                                  if (temp != null) {
                                    setState(() {
                                      depDate.text =
                                          DateFormat('yyyy-MM-dd').format(temp);
                                      selectedDepDate = temp;
                                    });
                                  }
                                },
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: arrDate,
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.calendar_month),
                                        hintText: "Arrival Date",
                                      ),
                                      onTap: () async {
                                        selectedArrDate = await showDatePicker(
                                          context: context,
                                          initialDate: selectedDepDate!,
                                          firstDate: selectedDepDate!,
                                          lastDate: DateTime(2100),
                                        );

                                        if (selectedArrDate != null) {
                                          setState(() {
                                            arrDate.text =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(selectedArrDate!);
                                          });
                                        }
                                      }))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          //Time of the flight
                          Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required Field";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: depTime,
                                readOnly: true,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.timer),
                                  hintText: "Departure Time",
                                ),
                                onTap: () async {
                                  final TimeOfDay? pickedTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (pickedTime != null) {
                                    setState(() {
                                      depTime.text = pickedTime.format(context);
                                      selectedDepTime = pickedTime;
                                    });
                                  }
                                },
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: arrTime,
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.timer),
                                        hintText: "Arrival Time",
                                      ),
                                      onTap: () async {
                                        final TimeOfDay? selectTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (selectTime != null) {
                                          setState(() {
                                            arrTime.text =
                                                selectTime.format(context);
                                            selectedArrTime = selectTime;
                                          });
                                        }
                                      }))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //End of time of flight

                          Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        }

                                        if (!RegExp(r'^[a-z A-Z]+$')
                                            .hasMatch(value)) {
                                          return 'Incorrect Airport';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: fromAir,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.connecting_airports),
                                        hintText: "From Airport",
                                      ))),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        }

                                        if (!RegExp(r'^[a-z A-Z]+$')
                                            .hasMatch(value)) {
                                          return 'Incorrect Airport';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: toAir,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        icon:
                                            Icon(Icons.airplanemode_on_rounded),
                                        hintText: "To Airport",
                                      )))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        }

                                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                                          return 'Please Enter an integer';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: numOfGuest,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.man_4),
                                        hintText: "Guest Seats",
                                      ))),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        }

                                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                                          return 'Please Enter an integer';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: numOfBusiness,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.man),
                                        hintText: "Business Seats",
                                      )))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required Field";
                                        }

                                        if (!RegExp(r'^\d+(\.\d+)?$')
                                            .hasMatch(value)) {
                                          return 'Please a price';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: guestPrice,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.attach_money),
                                        hintText: "Guset Price",
                                      ))),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Required Field";
                                  }

                                  if (!RegExp(r'^\d+(\.\d+)?$')
                                      .hasMatch(value)) {
                                    return 'Please a price';
                                  } else {
                                    return null;
                                  }
                                },
                                controller: businessPrice,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.attach_money),
                                  hintText: "Business Price",
                                ),
                              ))
                            ],
                          ),
                          TextButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  try {
                                    DateTime departur = DateTime(
                                        selectedDepDate!.year,
                                        selectedDepDate!.month,
                                        selectedDepDate!.day,
                                        selectedDepTime.hour,
                                        selectedDepTime.minute);

                                    DateTime arriv = DateTime(
                                        selectedArrDate!.year,
                                        selectedArrDate!.month,
                                        selectedArrDate!.day,
                                        selectedArrTime.hour,
                                        selectedArrTime.minute);

                                    if (departur.isBefore(arriv)) {
                                      DateTime dateTimeDep = DateTime(
                                          1980,
                                          1,
                                          1,
                                          selectedDepTime.hour,
                                          selectedDepTime.minute);

                                      DateTime dateTimeArr = DateTime(
                                          1980,
                                          1,
                                          1,
                                          selectedArrTime.hour,
                                          selectedArrTime.minute);

                                      createFlight(
                                          fromCity: from.text,
                                          toCity: to.text,
                                          fromAirport: fromAir.text,
                                          toAirport: toAir.text,
                                          numOfBusiness: numOfBusiness.text,
                                          numOfGuest: numOfGuest.text,
                                          guestPrice: guestPrice.text,
                                          busPrice: businessPrice.text,
                                          depDate: selectedDepDate,
                                          arrDate: selectedArrDate,
                                          arrTime: dateTimeArr,
                                          depTime: dateTimeDep);

                                      clearAllFields();
                                      await showFeedback(
                                          context, 'Flight Added');
                                    } else {
                                      await showErrorDialog(context,
                                          'The arrival  must be after the departure ');
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              child: const Text('Add')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(addAdminRoute);
                              },
                              child: const Text('Add Admin')),
                          ElevatedButton(
                            onPressed: () {
                              AuthService.firebase().logOut();
                              Navigator.of(context).pushNamed(loginRoute);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              child: Text(
                                'Sign Out',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ));
  }
}