import 'package:AirTours/constants/pages_route.dart';
import 'package:AirTours/services_auth/auth_exceptions.dart';
import 'package:AirTours/utilities/show_error.dart';
import 'package:AirTours/utilities/show_feedback.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_service.dart';



class UpdateEmailView extends StatefulWidget {
  const UpdateEmailView({super.key});

  @override
  State<UpdateEmailView> createState() => _UpdateEmailViewState();
}

class _UpdateEmailViewState extends State<UpdateEmailView> {
  late final TextEditingController _email;
  final FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'New Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
                onPressed: () async {
                  String newEmail = _email.text;
                  if (newEmail.isNotEmpty) {
                    try {
                      await AuthService.firebase().updateUserEmail(email: newEmail); 

                       //DB
                      final String currentUser =
                      AuthService.firebase().currentUser!.id;
                     c.updateUser(
                        ownerUserId: currentUser,
                        email: newEmail,
                        phoneNum: "0580647715"
                        //DB end

                      );
                      await showFeedback(context, 'Information Updated'); 
                      await AuthService.firebase().logOut();
                      await Navigator.of(context).pushNamed(loginRoute);
                    } on EmailAlreadyInUseAuthException {
                      await showErrorDialog(context, 'Email Already Used');
                    } on InvalidEmailAuthException {
                      await showErrorDialog(context, 'Invalid Email');
                    } on GenericAuthException {
                      await showErrorDialog(context, 'Updating Error');
                    }
                    
                  } else {
                    await showErrorDialog(context, 'Please Write The New Email');
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
