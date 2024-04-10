import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/pages/login_screen.dart';
import 'package:firebase_practice/signup_code.dart';
import 'package:firebase_practice/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
   Utils utils = Utils();
   SignupCode signupCode = SignupCode();
   bool isLoading = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text(
          'Sign up ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
     //   automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value!.length <6) {
                    return 'Password at least 6 char';
                  }
                },
                decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    signupCode.signUpUser( emailController.text,
                    passwordController.text,
                    (bool loading) {
                      setState(() {
                        isLoading = loading;
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: isLoading?const CircularProgressIndicator(color:
                  Colors.white,strokeWidth: 5,):const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>const LoginScreen(),));
                  },
                  child: const Text('Login',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize: 16),),
                )

              ],
            )
          ],
        ),
      ),
    );
  }

  // void signupCode(){
  //     setState(() {
  //       isLoading = true;
  //     });
  //     if (_formKey.currentState!.validate()) {
  //       _firebaseAuth.createUserWithEmailAndPassword(
  //         email: emailController.text.trim(), // It's good practice to trim the input
  //         password: passwordController.text.trim(),
  //       ).then((value) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       }).catchError((error) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         utils.toastMsg(error.toString());
  //       });
  //     }
  // }
}
