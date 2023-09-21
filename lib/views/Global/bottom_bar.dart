import 'package:flutter/material.dart';

import '../Manage_booking/view_bookings.dart';
import '../One-Way/one_way.dart';
import '../Round-Trip/round_trip.dart';
import '../profile/ProfileView.dart';
import 'display_history.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int indexx = 0;
  final pages = [
    const Center(child: SelectTravelType()),
    const Center(child: History()),
    const Center(child: ViewBookings()),
    const Center(child: ProfileView()),
  ];
  Widget pageNumber(int page) {
    final pages = [
      const Center(child: SelectTravelType()),
      const Center(child: History()),
      const Center(child: ViewBookings()),
      const Center(child: ProfileView()),
    ];
    return pages[page];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[indexx],
      bottomNavigationBar: GNav(
          gap: 8,
          backgroundColor: Colors.blue,
          color: Colors.black,
          activeColor: Colors.white,
          //tabBackgroundColor: Colors.white,
          onTabChange: (value) {
            setState(() {
              indexx = value;
            });
          },
          tabs: [
            GButton(
              onPressed: () => const SelectTravelType(),
              icon: Icons.home,
              text: "Home",
            ),
            const GButton(
              icon: Icons.history_sharp,
              text: "History",
            ),
            const GButton(
              icon: Icons.manage_history_sharp,
              text: "Manage",
            ),
            GButton(
              onPressed: () => const ProfileView(),
              icon: Icons.person_2_sharp,
              text: "Profile",
            )
          ]),
    );
  }
}

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
          // appBar: AppBar(title: Text("Switch")),
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
                      tabs: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Tab(text: "One way"), Icon(Icons.flight)],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Tab(
                              text: "Round trip",
                            ),
                            Image.asset('images/RoundTrip.jpeg'),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Expanded(
                      child: TabBarView(children: [OneWay(), RoundTrip()]))
                ],
              ),
            ),
          )),
    );
  }
}