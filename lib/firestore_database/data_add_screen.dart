import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class AddDataToFirestore extends StatefulWidget {
  const AddDataToFirestore({Key? key}) : super(key: key);

  @override
  State<AddDataToFirestore> createState() => _AddDataToFirestoreState();
}

class _AddDataToFirestoreState extends State<AddDataToFirestore> {
  final infoController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('myTable');


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              maxLines: 3,
              controller: infoController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Bio-Data'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  firestore.doc(id).set({
                    'description':infoController.text.toString(),
                    'id':id
                  }).then((value) {
                    Utils().toastMsg('added successfully');
                  }).onError((error, stackTrace) {
                    Utils().toastMsg(error.toString());
                  });
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
    );
  }
}
