import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('imageTable');

  Future getGalleryImage() async {
    final file =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (file != null) {
      setState(() {
        _image = File(file.path);
        print(_image.toString());
      });
    } else {
      Utils().toastMsg('Image not selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                getGalleryImage();
              },
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select Image',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _image == null
                        ? Icon(
                            Icons.image,
                            size: 70,
                          )
                        : Image.file(
                            _image!.absolute,
                            height: 200,
                            width: 200,
                          ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  loading = true;
                });
                firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/myFolder/'+DateTime.now().millisecondsSinceEpoch.toString());
                firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

                Future.value(uploadTask).then((value) async {
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  var newUrl = await ref.getDownloadURL();
                  databaseRef.child(id).set({
                    'image':newUrl.toString()
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMsg('Uploaded');
                  }).onError((error, stackTrace) {

                    setState(() {
                      loading = false;
                    });
                    Utils().toastMsg(error.toString());
                  });
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMsg(error.toString());
                });
              },
              child: loading == true ?CircularProgressIndicator(): Text('Upload'),
            )
          ],
        ),
      ),
    );
  }
}
