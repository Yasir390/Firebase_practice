import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_practice/realtime_database/add_info_database.dart';
import 'package:firebase_practice/pages/login_screen.dart';
import 'package:firebase_practice/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final searchController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _ref = FirebaseDatabase.instance.ref('myTable');
  final editNameController = TextEditingController();
  final editStuIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post Screen',
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: 'Search', border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
              child: FirebaseAnimatedList(
            query: _ref,
            itemBuilder: (context, snapshot, animation, index) {
              final name = snapshot.child('Name').value.toString();
              final stuId = snapshot.child('Student Id').value.toString();
              final uniqueId = snapshot.child('Unique Id').value.toString();

              if (searchController.text.isEmpty) {
                return ListTile(
                  title: Text(name),
                  subtitle: Text(stuId),
                  trailing: PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            showMyDialog(name, stuId, uniqueId);
                            },
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        onTap: () {
                          _ref.child(uniqueId).remove();
                        },
                        child: const ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                        ),
                      )
                    ],
                  ),
                );
              } else if (name
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase())) {
                return ListTile(
                  title: Text(snapshot.child('Name').value.toString()),
                  subtitle: Text(snapshot.child('Student Id').value.toString()),
                );
              } else {
                return Container();
              }
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddInfoToDatabase(),
                ));
          },
          child: const Icon(Icons.add)),
    );
  }

  Future<void> showMyDialog(String name,String stuId,String uniqueId) {
    editNameController.text = name.toString();
    editStuIdController.text = stuId.toString();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: editNameController,
                    decoration: const InputDecoration(
                        hintText: 'Name', border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: editStuIdController,
                    decoration: const InputDecoration(
                        hintText: 'Stu Id', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
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
                _ref.child(uniqueId).update( {
                  'Name':editNameController.text.toString(),
                  'Student Id':editStuIdController.text.toString(),
                }).then((value) {
                  Utils().toastMsg('Updated successfully');
                }).onError((error, stackTrace) {
                  Utils().toastMsg(error.toString());
                });
              },
              child: const Text('Update'),
            ),],);
        },
    );
  }
}
