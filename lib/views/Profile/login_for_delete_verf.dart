import 'package:AirTours/constants/pages_route.dart';
import 'package:AirTours/utilities/show_feedback.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/auth_service.dart';
import '../../utilities/show_error.dart';



class LoginForDelete extends StatefulWidget {
  const LoginForDelete({super.key});

  @override
  State<LoginForDelete> createState() => _LoginForDeleteState();
}

class _LoginForDeleteState extends State<LoginForDelete> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final FirebaseCloudStorage c = FirebaseCloudStorage();


  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login To Verify It Is You'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'Your Email',
              ),
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                labelText: 'Your Password',
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
                onPressed: () async {
                  try {
                  await AuthService.firebase().logIn(email: _email.text, password: _password.text);
                  final userId = AuthService.firebase().currentUser!.id;
                  await c.deleteUser(ownerUserId: userId);
                  await showFeedback(context, 'Account Deleted');
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                    welcomeRoute,
                     (route) => false
                     );
                  }
                  on UserNotFoundAuthException {
                      await showErrorDialog(context, 'User not found');
                    } on WrongPasswordAuthException {
                      await showErrorDialog(context, 'Wrong credentials');
                    } on GenericAuthException {
                      await showErrorDialog(context, 'Authentication Error');
                    } 
                },
                child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
