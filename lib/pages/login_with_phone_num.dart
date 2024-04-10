import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/pages/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
   var phoneNumber;
  bool loading = false;


  FocusNode focusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login with phone number',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IntlPhoneField(
                   focusNode: focusNode,
                  initialCountryCode: 'BD',
                  invalidNumberMessage: 'Enter correct phone number',
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  languageCode: "en",
                  onChanged: (phone) {
                    phoneNumber = phone.completeNumber;
                  },

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading=true;
                        });
                        _firebaseAuth.verifyPhoneNumber(
                          phoneNumber: phoneNumber.toString(),
                          verificationCompleted: (PhoneAuthCredential credential ) {},
                          codeSent: (String verificationId, int? forceResendingToken) {
                            setState(() {loading=false;});
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                OtpScreen(verificationId: verificationId.toString(),) ,));
                          },
                          verificationFailed: (FirebaseAuthException ex) {
                            setState(() {
                              loading=false;
                            });},
                          codeAutoRetrievalTimeout: (String verificationId) {
                            setState(() {
                              loading=false;
                            });
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child:loading?const CircularProgressIndicator(): const Text(
                      'Send OTP',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
