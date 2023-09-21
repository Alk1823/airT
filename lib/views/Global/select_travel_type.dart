import 'package:flutter/material.dart';
import 'package:AirTours/views/One-Way/one_way.dart';
import 'package:AirTours/views/Round-Trip/round_trip.dart';

class SelectTravelType extends StatefulWidget {
  const SelectTravelType({super.key});

  @override
  State<SelectTravelType> createState() => _SelectTravelTypeState();
}

class _SelectTravelTypeState extends State<SelectTravelType> {
  List<String> selectType = ["One Way", "Round Trip"];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TabBar(
                      indicator: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(25)),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Tab(text: "One way"), Icon(Icons.flight)],
                        ),
                        Tab(
                          text: "Round trip",
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(children: [
                    OneWay(),
                    const Center(
                      child: RoundTrip(),
                    )
                  ]))
                ],
              ),
            ),
          )),
    );
  }
}
