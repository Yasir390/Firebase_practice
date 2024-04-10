import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/utils.dart';
import 'package:flutter/material.dart';


class AddInfoToDatabase extends StatefulWidget {
  const AddInfoToDatabase({Key? key}) : super(key: key);

  @override
  State<AddInfoToDatabase> createState() => _AddInfoToDatabaseState();
}

class _AddInfoToDatabaseState extends State<AddInfoToDatabase> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  // create a table on database which name My Table
  final databaseRef = FirebaseDatabase.instance.ref('myTable');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textAlign: TextAlign.center,
              controller:nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name'
              ),
              validator: (value) {
                if(value!.isEmpty){
                  return 'Write Name';
                }
                return '';
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textAlign: TextAlign.center,
              controller:studentIdController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Student Id'
              ),
              validator: (value) {
                if(value!.isEmpty){
                  return 'Write Student Id';
                }
                return '';
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(

                onPressed: () async {
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                await  databaseRef.child(id).set({
                    'Unique Id': id,
                    'Name': nameController.text.toString(),
                    'Student Id': studentIdController.text.toString(),
                  }).then((value) {
                    Utils().toastMsg('Added to Database');
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
