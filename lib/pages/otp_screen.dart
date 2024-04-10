import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/pages/post_screen.dart';
import 'package:firebase_practice/style.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
 final String verificationId;
   OtpScreen({super.key,required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //var otp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            const SizedBox(height: 20,),
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.scale,
              pinTheme: Style().pinTheme,
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: Colors.blue.shade50,
              enableActiveFill: true,
              controller: otpController,
            ),


            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: ()async {
                    if (_formKey.currentState!.validate()) {
                      PhoneAuthCredential credential =  PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: otpController.text.toString()
                      );

                      try{
                    await _firebaseAuth.signInWithCredential(credential).then((value) {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const PostScreen(),));
                   });
                      }catch(e){
                        print(e.toString());
                        throw Exception(e.toString());

                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
