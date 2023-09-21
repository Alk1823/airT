import 'package:AirTours/constants/pages_route.dart';
import 'package:flutter/material.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/auth_service.dart';
import '../../utilities/show_error.dart';



class LoginForPasswordChanges extends StatefulWidget {
  const LoginForPasswordChanges({super.key});

  @override
  State<LoginForPasswordChanges> createState() => _LoginForPasswordChangesState();
}

class _LoginForPasswordChangesState extends State<LoginForPasswordChanges> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      updatePasswordRoute, 
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
