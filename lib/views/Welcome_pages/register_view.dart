import 'package:flutter/material.dart';

import '../../constants/pages_route.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/auth_service.dart';
import '../../utilities/button.dart';
import '../../utilities/show_error.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final FirebaseCloudStorage c = FirebaseCloudStorage();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _password2;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _password2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _password2.dispose();
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
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color.fromRGBO(137, 147, 158, 1)),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5),
                ),
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
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter Password',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepPurple, width: 3)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _password2,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 3))),
                ),
              ),
              const SizedBox(height: 30),
              MyButton(
                  title: 'Register',
                  onPressed: () async {
                    final email = _email.text;
                    final pass = _password.text;
                    final pass2 = _password2.text;
                    if (pass != pass2) {
                      showErrorDialog(context, "Password Doesn't Match!");
                    } else {
                      try {
                        await AuthService.firebase()
                            .createUser(email: email, password: pass);

                        //DB
                        final String userId =
                            AuthService.firebase().currentUser!.id;
                        final String currentEmail =
                            AuthService.firebase().currentUser!.email;
                        c.createNewUser(
                            ownerUserId: userId,
                            email: currentEmail,
                            phoneNum: '',
                            balance: 0.0);
                        //DB end
                        AuthService.firebase().sendEmailVerification();
                        await Navigator.of(context).pushNamed(verficationRoute);

                      } on WeakPasswordAuthException {
                        await showErrorDialog(context, 'Weak Password');
                      } on EmailAlreadyInUseAuthException {
                        await showErrorDialog(context, 'Email Already In Use');
                      } on InvalidEmailAuthException {
                        await showErrorDialog(
                            context, 'This Is An Invalid Email');
                      } on GenericAuthException {
                        await showErrorDialog(context, 'Failed To Register');
                      }
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already Registered?'),
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, (route) => false);
                      },
                      child: const Text('Login Here'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
