import 'package:AirTours/constants/pages_route.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/auth_service.dart';
import '../../utilities/show_error.dart';
import '../../utilities/show_feedback.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _phoneNum;
  final FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _phoneNum = TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _phoneNum,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                 try {           
                   await AuthService.firebase()
                       .createUser(email: _email.text, password: _password.text);
                   //DB
                   c.createNewAdmin(
                       email: _email.text, phoneNum: _phoneNum.text);
                   //DB end
                   await showFeedback(context, 'Admin Added');
                   await Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                     (route) => false
                     );
                 } on WeakPasswordAuthException {
                   await showErrorDialog(context, 'Weak Password');
                } on EmailAlreadyInUseAuthException {
                   await showErrorDialog(context, 'Email Already In Use ');
                 } on InvalidEmailAuthException {
                   await showErrorDialog(context, 'This Is An Invalid Email');
                 } on GenericAuthException {
                   await showErrorDialog(context, 'Failed To Add');
                 }
              },
              child: const Text('Add Admin'),
            ),
          ],
        ),
      ),
    );
  }
}

