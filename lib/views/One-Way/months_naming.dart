// import 'package:flutter/material.dart';

// class MyDateRangePicker extends StatefulWidget {
//   const MyDateRangePicker({super.key});

//   @override
//   _MyDateRangePickerState createState() => _MyDateRangePickerState();
// }

// class _MyDateRangePickerState extends State<MyDateRangePicker> {
//   DateTime _startDate = DateTime.now();
//   DateTime _endDate = DateTime.now().add(const Duration(days: 7));

//   Future<void> _selectDateRange(BuildContext context) async {
//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//       initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
//     );
//     if (picked != null) {
//       setState(() {
//         _startDate = picked.start;
//         _endDate = picked.end;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Date Range Picker'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Selected Dates:',
//               style: TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               '${_startDate.toLocal().toString().split(' ')[0]} - ${_endDate.toLocal().toString().split(' ')[0]}',
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _selectDateRange(context),
//               child: const Text('Select Date Range'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
