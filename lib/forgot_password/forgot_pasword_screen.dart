import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/utils.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final mailController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password '),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: mailController,
                decoration: const InputDecoration(
                  hintText: 'Enter mail',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _firebaseAuth.sendPasswordResetEmail(
                  email: mailController.text.toString()).then((value) {
                Utils().toastMsg('Mail sent. Check mailbox and spam');
              }).onError((error, stackTrace) {
                Utils().toastMsg(error.toString());
              });
            },
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }
}
