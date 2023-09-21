import 'package:AirTours/services_auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../../constants/pages_route.dart';
import '../../utilities/button.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  child: Image.asset('img/email.png'),
                ),
                const Text(
                  'Check Your Email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyButton(
                    title: 'After Confirmation, Login here',
                    onPressed: () async {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not Verified Yet? '),
                    TextButton(
                        onPressed: () async {
                          await AuthService.firebase().sendEmailVerification();
                        },
                        child: const Text('Send Verfication Again')),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
