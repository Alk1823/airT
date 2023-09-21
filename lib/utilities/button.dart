import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        borderRadius: BorderRadius.circular(100),
        elevation: 10,
        color: Colors.deepPurple,
        child: MaterialButton(
            onPressed: onPressed,
            height: 45,
            minWidth: 200,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
