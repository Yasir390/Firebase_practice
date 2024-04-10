import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../image_upload/upload_image.dart';
import '../pages/login_screen.dart';

class SplashServices{


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  void isLogin(BuildContext context){
   if( _firebaseAuth.currentUser != null){
     Timer(const Duration(seconds: 3), () {
       Navigator.push(context, MaterialPageRoute(builder: (context)
       => const LoginScreen()));
     });
   }else{
     Timer(const Duration(seconds: 3), () {
       Navigator.push(context, MaterialPageRoute(builder: (context)
       =>  const LoginScreen()));
     });
   }
  }
}
