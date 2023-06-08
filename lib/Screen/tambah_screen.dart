import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class TambahScreen extends StatefulWidget {
  // const MyWidget({Key? key}) : super(key: key);

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  // final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _namaController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _tiketController = TextEditingController();

  // Baru
  File? _imageFile;
  String? _imageUrl;
  bool switchValue = false;
  bool switchValueCamp = false;

  var currentStep = 0;
  String selectedOption = 'Air Terjun';
  String selectedOptionDesa = 'Tapos I';

  void saveDataToFirestore() {
    String name = _namaController.text;

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore
        .collection('users')
        .add({
          "nama": _namaController.text,
          "image": _imageUrl,
          "desc": _descController,
          "kec": "Kecamatan Tenjolaya",
          "tiket": _tiketController,
          // tambahkan properti lain sesuai kebutuhan
        })
        .then((value) => print('Data berhasil disimpan'))
        .catchError((error) => print('Gagal menyimpan data: $error'));
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      // Jika gambar belum dipilih, tidak melakukan upload
      return print("object");
    }

    try {
      // Upload gambar ke Firebase Storage
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}.jpg');
      firebase_storage.UploadTask uploadTask = ref.putFile(_imageFile!);

      // Menunggu penyelesaian upload
      await uploadTask.whenComplete(() {});

      // Dapatkan URL download gambar
      String downloadUrl = await ref.getDownloadURL();

      // Simpan URL download gambar
      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (e) {
      // Tangani kesalahan jika ada
      print('Error uploading image: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        _uploadImage();
        if (_imageUrl != null) {
          deleteImageFromFirebase(_imageUrl!);
        }
      }
    });
  }

  Future<void> deleteImageFromFirebase(String imageUrl) async {
    final ref = FirebaseStorage.instance.refFromURL(imageUrl);
    // Menghapus gambar dari Firebase Storage
    await ref.delete();
  }

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Text("Page 1"),
            content: Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => _pickImage(),
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
                      child: _imageUrl != null
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: Image.network(
                                _imageUrl!.toString(),
                                fit: BoxFit.cover,
                              ),
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
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: "Nama Wisata",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text("Desa :"),
                      const SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        itemHeight: kMinInteractiveDimension + 5,
                        value: selectedOptionDesa,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOptionDesa = newValue!;
                          });
                        },
                        items: <String>[
                          'Tapos I',
                          'Tapos II',
                          'Gunung Malang',
                          'Cibitung Tengah'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  Row(
                    children: [
                      const Text("Kategori :"),
                      const SizedBox(
                        width: 10,
                      ),
                      DropdownButton<String>(
                        itemHeight: kMinInteractiveDimension + 5,
                        value: selectedOption,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOption = newValue!;
                          });
                        },
                        items: <String>[
                          'Air Terjun',
                          'Rekreasi',
                          'Situs Prasejarah'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descController,
                    maxLines:
                        null, // Mengatur jumlah baris menjadi null agar dapat menampung teks yang panjang
                    decoration: InputDecoration(
                      hintText: 'Deskripsi',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                    ),
                  ),
                  Visibility(
                    visible: _imageFile != null ? true : false,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: _uploadImage,
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
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: const Text("Page 2"),
            content: Column(children: [
              Row(
                children: [
                  const Text("Penginapan / Camping :"),
                  const SizedBox(
                    width: 10,
                  ),
                  Switch(
                    value: switchValueCamp,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool newValue) {
                      setState(() {
                        switchValueCamp = newValue;
                      });
                    },
                  ),
                ],
              )
            ])),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: const Text("Page 3"),
            content: Column(children: [
              TextFormField(
                controller: _tiketController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Tiket",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                ),
              ),
              Row(
                children: [
                  const Text("Tutup Sementara :"),
                  const SizedBox(
                    width: 10,
                  ),
                  Switch(
                    value: switchValue,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool newValue) {
                      setState(() {
                        switchValue = newValue;
                      });
                    },
                  ),
                ],
              )
            ]))
      ];

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
        body: Theme(
          data: Theme.of(context).copyWith(
              colorScheme:
                  ColorScheme.light(primary: Theme.of(context).primaryColor)),
          child: Stepper(
            elevation: 0,
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: currentStep,
            onStepContinue: () {
              final isLastStep = currentStep == getSteps().length - 1;
              if (isLastStep) {
                print("Completed");
              } else {
                setState(() {
                  currentStep += 1;
                });
              }
            },
            onStepCancel: currentStep == 0
                ? null
                : () {
                    setState(() {
                      currentStep -= 1;
                    });
                  },
            onStepTapped: (step) => setState(() {
              currentStep = step;
            }),
          ),
        ));
  }
}
