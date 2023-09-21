import 'package:AirTours/constants/pages_route.dart';
import 'package:AirTours/services_auth/auth_exceptions.dart';
import 'package:AirTours/utilities/show_error.dart';
import 'package:AirTours/utilities/show_feedback.dart';
import 'package:flutter/material.dart';
import '../../services_auth/auth_service.dart';



class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  State<UpdatePasswordView> createState() => _UpdatePasswordViewState();
}

class _UpdatePasswordViewState extends State<UpdatePasswordView> {
  late final TextEditingController _password;

  @override
  void initState() {
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
                onPressed: () async {
                  String newPassword = _password.text;
                  if (newPassword.isNotEmpty) {
                    try {
                      await AuthService.firebase().updateUserPassword(password: newPassword); 
                      await showFeedback(context, 'Information Updated'); 
                      await AuthService.firebase().logOut();
                      await Navigator.of(context).pushNamed(loginRoute);
                    } on WeakPasswordAuthException { 
                      await showErrorDialog(context, 'Weak Password');
                    } on GenericAuthException {
                      await showErrorDialog(context, 'Updating Error');
                    }    
                  } else {
                    await showErrorDialog(context, 'Please Write The New Password');
                  }
                },
                child: const Text('Update!')),
                TextButton(
                  onPressed: () async {
                    await Navigator.of(context).pushNamedAndRemoveUntil(
                      bottomRoute,
                     (route) => false
                     );
                  },
                   child: const Text('Cancel')
                   )
          ],
        ),
      ),
    );
  }
}
