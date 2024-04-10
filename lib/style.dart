import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Style{

 final pinTheme = PinTheme(

  shape: PinCodeFieldShape.box,
  borderRadius: BorderRadius.circular(5),
  fieldHeight: 50,
  fieldWidth: 40,
  selectedColor: Colors.orange,
  selectedFillColor: Colors.white,
  activeFillColor: Colors.white,
  activeColor: Colors.teal,
  inactiveColor: Colors.teal,
  inactiveFillColor: Colors.white,

  );
}