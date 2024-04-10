import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

 class Utils{

   void toastMsg(String msg){
     Fluttertoast.showToast(
       msg: msg.toString(), // Showing the error message returned by Firebase
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.BOTTOM,
       timeInSecForIosWeb: 1,
       backgroundColor: Colors.red,
       textColor: Colors.white,
       fontSize: 16.0,
     );
   }
 }


