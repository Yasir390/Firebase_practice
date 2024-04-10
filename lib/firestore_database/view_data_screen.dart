import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/login_screen.dart';
import '../utils.dart';
import 'data_add_screen.dart';

class ViewFirestoreData extends StatefulWidget {
  const ViewFirestoreData({Key? key}) : super(key: key);

  @override
  State<ViewFirestoreData> createState() => _ViewFirestoreDataState();
}

class _ViewFirestoreDataState extends State<ViewFirestoreData> {
  final firestore =  FirebaseFirestore.instance.collection('myTable').snapshots();
  final firestoreRef = FirebaseFirestore.instance.collection('myTable');

  final updateController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Firestore Data',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              _firebaseAuth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              }).onError((error, stackTrace) {
                Utils().toastMsg(error.toString());
              });
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: firestore,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );}
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Some Error'),);
              } else {
                return Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String des = snapshot.data!.docs[index]['description'].toString();
                    String uniqueId = snapshot.data!.docs[index]['id'].toString();
                    return ListTile(
                      title: Text(des),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              onTap: () {
                                showMyDialog(des, uniqueId);
                              },
                              child: const ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              )),
                          PopupMenuItem(
                              value: 1,
                              onTap: () {
                                firestoreRef.doc(uniqueId).delete();
                              },
                              child: const ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                              )),
                        ],
                      ),
                    );
                  },
                ));
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddDataToFirestore(),
                ));
          },
          child: const Icon(Icons.add)),
    );
  }

  Future<void> showMyDialog(String des, String uniqueId) {
    updateController.text = des.toString();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: Column(
          mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: updateController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      hintText: 'Update', border: OutlineInputBorder()),
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                firestoreRef.doc(uniqueId).update( {
                  'description':updateController.text.toString(),

                }).then((value) {
                  Utils().toastMsg('Added');
                }).onError((error, stackTrace) {
                  Utils().toastMsg(error.toString());
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
