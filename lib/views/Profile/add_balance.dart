
import 'package:AirTours/utilities/show_error.dart';
import 'package:AirTours/views/Profile/balance_credit_card.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/firebase_cloud_storage.dart';


class AddBalance extends StatefulWidget {
  const AddBalance({super.key});



  @override
  State<AddBalance> createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  late final TextEditingController _amount;
  final FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  void initState() {
    _amount = TextEditingController();
    super.initState();
  } 

  bool isNumber(String amount) { 
    final numbersAllowed = RegExp(r'^[0-9]+(\.[0-9]+)?$');
    return numbersAllowed.hasMatch(amount);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adding Balance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amount,
              decoration: const InputDecoration(
                labelText: 'Amount Required',
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () async {
              final balance = _amount.text;
              if (balance.isEmpty) {
                await showErrorDialog(context, 'Write The Amount');
              } else if (isNumber(balance)) {
                final amountInDouble = double.parse(balance);
                if (amountInDouble > 0) {
                  Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => ChargeBalance(balance: balance), 
                  ));
                } else {
                  await showErrorDialog(context, 'Write Valid Amount');
                }
              }
              else if (!isNumber(balance)) {
                await showErrorDialog(context, 'Write Valid Amount');
              }
              } ,
                child: const Text('Add The Amount'))
          ],
        ),
      ),
    );
  }
}