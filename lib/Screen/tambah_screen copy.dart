import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahScreenCopy extends StatefulWidget {
  // const MyWidget({Key? key}) : super(key: key);

  @override
  State<TambahScreenCopy> createState() => _TambahScreenCopyState();
}

class _TambahScreenCopyState extends State<TambahScreenCopy> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  XFile? selectedImage;

  Uint8List? _image;

  pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      return await pickedImage.readAsBytes();
    }
    return print("No images selected");
  }

  selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<String> uploadImageToFirebase(String childName, Uint8List file) async {
    Reference Ref = storage.ref().child(childName);
    // final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = Ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({required Uint8List file}) async {
    String resp = 'Error Upload';
    try {
      String imageUrl = await uploadImageToFirebase('images', file);
      if (file == null) {
        print("object");
      }
      print(imageUrl.toString());
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }

  // void chooseAndUploadImage() async {
  //   final image = await pickImage();
  //   if (image != null) {
  //     setState(() {
  //       selectedImage = image;
  //     });
  //     final imageUrl = await uploadImageToFirebase(image);
  //     print('URL Gambar: $imageUrl');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Tambah Data Wisata",
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // ElevatedButton(
                  //   style: ButtonStyle(
                  //     backgroundColor:
                  //         MaterialStateProperty.all<Color>(Colors.white),
                  //   ),
                  //   onPressed: UploadImage,
                  //   child: const Text(
                  //     'Pilih Gambar',
                  //     style: TextStyle(color: Colors.blue),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () => selectImage(),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: _image != null
                          ? Image(
                              image: MemoryImage(_image!),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text('Upload',
                                    style: TextStyle(color: Colors.blue)),
                                Text('Gambar',
                                    style: TextStyle(color: Colors.blue)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nama Wisata",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Desa",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Kecamatan",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: _image != null ? true : false,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        // saveData(file: _image!);
                        if (_image != null) {
                          saveData(file: _image!);
                        }
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}

Future<String> UploadFile(File file) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  Reference reference = storage.ref().child('images/${file.path}');
  UploadTask uploadTask = reference.putFile(file);
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
  String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}
