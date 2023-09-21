// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../constants/pages_route.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/auth_service.dart';
import '../../utilities/button.dart';
import '../../utilities/show_error.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                child: Image.asset('img/tours3.png'),
              ),
              const Text(
                'AirTours',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(137, 147, 158, 1),
                    fontSize: 40,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: 'Enter Email',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 3))),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[100]),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Enter Password',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 3))),
                ),
              ),
              const SizedBox(height: 30),
              MyButton(
                  title: 'Login',
                  onPressed: () async {
                    final email = _email.text;
                    final pass = _password.text;
                    try {
                      await AuthService.firebase()
                          .logIn(email: email, password: pass);
                      final user = AuthService.firebase().currentUser;
                      final isUserr = await c.isUser(ownerUserId: user!.id);
                      if (isUserr) {
                        if (user.isEmailVerified) {
                          await Navigator.of(context).pushNamedAndRemoveUntil(
                              bottomRoute, (route) => false);
                        } else {
                          await Navigator.of(context).pushNamedAndRemoveUntil(
                              verficationRoute, (route) => false);
                        }
                      } else {
                        await Navigator.of(context).pushNamedAndRemoveUntil( //needs to verify the admin
                            createFlightRoute, (route) => false);
                      }
                    } on UserNotFoundAuthException {
                      await showErrorDialog(context, 'User Not Found');
                    } on WrongPasswordAuthException {
                      await showErrorDialog(context, 'Wrong Credentials');
                    } on GenericAuthException {
                      await showErrorDialog(context, 'Authentication Error');
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not Registered? ',
                  ),
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/register/', (route) => false);
                      },
                      child: const Text("Register Now"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
