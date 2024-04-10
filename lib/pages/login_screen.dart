import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/forgot_password/forgot_pasword_screen.dart';
import 'package:firebase_practice/pages/post_screen.dart';
import 'package:firebase_practice/pages/signup_screen.dart';
import 'package:firebase_practice/utils.dart';
import 'package:flutter/material.dart';

import 'login_with_phone_num.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void login(){
    _firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
        ).then((value) {
      Utils().toastMsg(value.user!.email.toString());
      Navigator.push(context, MaterialPageRoute(builder:(context) => const PostScreen(),));
    }).onError((error, stackTrace) {
      Utils().toastMsg(error.toString());
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login ',
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
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder()),
                  validator: ( value) {
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
                    if (value!.isEmpty) {
                      return 'Please enter password';
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
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>const SignupScreen(),));
                    },
                    child: const Text('Sign up',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize: 16),),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>const LoginWithPhone(),));
                    },
                    child: const Text('Login with phone number',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize: 16),),
                  )
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>const ForgotPasswordScreen(),));
                },
                child: const Text('Forgot Password?',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize: 16),),
              )



            ],
          ),
        ),
      ),
    );
  }
}
