import 'package:flutter/material.dart';
import '../../constants/pages_route.dart';
import '../../utilities/button.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
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
            MyButton(
                title: 'Sign Up',
                onPressed: () async {
                  Navigator.of(context).pushNamed(registerRoute);
                }),
            MyButton(
                title: 'Sign In',
                onPressed: () async {
                  Navigator.of(context).pushNamed(loginRoute);
                })
          ],
        ),
      ),
    );
  }
}
