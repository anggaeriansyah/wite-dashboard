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
  //Jam Controller
  TextEditingController _seninBukaController = TextEditingController();
  TextEditingController _seninTutupController = TextEditingController();
  TextEditingController _selasaBukaController = TextEditingController();
  TextEditingController _selasaTutupController = TextEditingController();
  TextEditingController _rabuBukaController = TextEditingController();
  TextEditingController _rabuTutupController = TextEditingController();
  TextEditingController _kamisBukaController = TextEditingController();
  TextEditingController _kamisTutupController = TextEditingController();
  TextEditingController _jumatBukaController = TextEditingController();
  TextEditingController _jumatTutupController = TextEditingController();
  TextEditingController _sabtuBukaController = TextEditingController();
  TextEditingController _sabtuTutupController = TextEditingController();
  TextEditingController _mingguBukaController = TextEditingController();
  TextEditingController _mingguTutupController = TextEditingController();
  TimeOfDay? _selectedOpeningTime;
  TimeOfDay? _selectedClosingTime;

  // Baru
  File? _imageFile;
  String? _imageUrl;
  bool switchValueTempClosed = false;
  bool switchValueCamp = false;
  bool _senin24Checked = false;
  bool _selasa24Checked = false;
  bool _rabu24Checked = false;
  bool _kamis24Checked = false;
  bool _jumat24Checked = false;
  bool _sabtu24Checked = false;
  bool _minggu24Checked = false;

  //untuk form input operasional
  bool _senin = false;
  bool _selasa = false;
  bool _rabu = false;
  bool _kamis = false;
  bool _jumat = false;
  bool _sabtu = false;
  bool _minggu = false;

  var currentStep = 0;
  int _totalInnerSteps = 2;
  var _currentInnerStep = 0;
  String selectedOptionKategori = 'air-terjun';
  String selectedOptionDesa = 'Tapos I';

  void saveDataToFirestore() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final wisata = <String, dynamic>{
      "nama": _namaController.text,
      "image": _imageUrl,
      "desa": selectedOptionKategori,
      "kec": "Kecamatan Tenjolaya",
      "tiket": int.parse(_tiketController.text),
      "desc": _descController.text,
      "tempClosed": switchValueTempClosed,
      "penginapan": switchValueCamp,
      "kategori": selectedOptionKategori,
      "hariOp": [_senin, _selasa, _rabu, _kamis, _jumat, _sabtu, _minggu],
      "hariOp": [
        _senin
            ? _senin24Checked
                ? "Buka 24 jam"
                : '$_seninBukaController - $_seninTutupController'
            : 'Tutup',
        _selasa
            ? _selasa24Checked
                ? "Buka 24 jam"
                : '$_selasaBukaController - $_selasaTutupController'
            : 'Tutup',
        _rabu
            ? _rabu24Checked
                ? "Buka 24 jam"
                : '$_rabuBukaController - $_rabuTutupController'
            : 'Tutup',
        _kamis
            ? _kamis24Checked
                ? "Buka 24 jam"
                : '$_kamisBukaController - $_kamisTutupController'
            : 'Tutup',
        _jumat
            ? _jumat24Checked
                ? "Buka 24 jam"
                : '$_jumatBukaController - $_jumatTutupController'
            : 'Tutup',
        _sabtu
            ? _sabtu24Checked
                ? "Buka 24 jam"
                : '$_sabtuBukaController - $_sabtuTutupController'
            : 'Tutup',
        _minggu
            ? _minggu24Checked
                ? "Buka 24 jam"
                : '$_mingguBukaController - $_mingguTutupController'
            : 'Tutup',
      ],
    };
    // firestore
    //     .collection('users')
    //     .add({
    //       "nama": _namaController.text,
    //       "image": _imageUrl,
    //       "desc": _descController.text,
    //       "kec": "Kecamatan Tenjolaya",
    //       "tiket": int.parse(_tiketController.text),
    //       "tempClosed": switchValueTempClosed,
    //       "penginapan": switchValueCamp,
    //       // tambahkan properti lain sesuai kebutuhan
    //     })
    // .then((value) => print('Data berhasil disimpan'))
    // .catchError((error) => print('Gagal menyimpan data: $error'));
    firestore.collection("wisata").add(wisata).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
    setState(() {
      Navigator.pop(context);
    });
  }

  Future<void> _selectOpeningTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedOpeningTime = selectedTime;
      });
    }
  }

  Future<void> _selectClosingTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedClosingTime = selectedTime;
      });
    }
  }

  Future<void> _selectTimeSeninB(BuildContext context) async {
    final TimeOfDay? seninBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (seninBukaTime != null) {
      _seninBukaController.text = seninBukaTime.format(context);
    }
  }

  Future<void> _selectTimeSeninT(BuildContext context) async {
    final TimeOfDay? seninTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (seninTutupTime != null) {
      _seninTutupController.text = seninTutupTime.format(context);
    }
  }

  Future<void> _selectTimeSelasaB(BuildContext context) async {
    final TimeOfDay? selasaBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selasaBukaTime != null) {
      _selasaBukaController.text = selasaBukaTime.format(context);
    }
  }

  Future<void> _selectTimeSelasaT(BuildContext context) async {
    final TimeOfDay? selasaTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selasaTutupTime != null) {
      _selasaTutupController.text = selasaTutupTime.format(context);
    }
  }

  Future<void> _selectTimeRabuB(BuildContext context) async {
    final TimeOfDay? rabuBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (rabuBukaTime != null) {
      _rabuBukaController.text = rabuBukaTime.format(context);
    }
  }

  Future<void> _selectTimeRabuT(BuildContext context) async {
    final TimeOfDay? rabuTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (rabuTutupTime != null) {
      _rabuTutupController.text = rabuTutupTime.format(context);
    }
  }

  Future<void> _selectTimeKamisB(BuildContext context) async {
    final TimeOfDay? kamisBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (kamisBukaTime != null) {
      _kamisBukaController.text = kamisBukaTime.format(context);
    }
  }

  Future<void> _selectTimeKamisT(BuildContext context) async {
    final TimeOfDay? kamisTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (kamisTutupTime != null) {
      _kamisTutupController.text = kamisTutupTime.format(context);
    }
  }

  Future<void> _selectTimeJumatB(BuildContext context) async {
    final TimeOfDay? jumatBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (jumatBukaTime != null) {
      _jumatBukaController.text = jumatBukaTime.format(context);
    }
  }

  Future<void> _selectTimeJumatT(BuildContext context) async {
    final TimeOfDay? jumatTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (jumatTutupTime != null) {
      _jumatTutupController.text = jumatTutupTime.format(context);
    }
  }

  Future<void> _selectTimeSabtuB(BuildContext context) async {
    final TimeOfDay? sabtuBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (sabtuBukaTime != null) {
      _sabtuBukaController.text = sabtuBukaTime.format(context);
    }
  }

  Future<void> _selectTimeSabtuT(BuildContext context) async {
    final TimeOfDay? sabtuTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (sabtuTutupTime != null) {
      _sabtuTutupController.text = sabtuTutupTime.format(context);
    }
  }

  Future<void> _selectTimeMingguB(BuildContext context) async {
    final TimeOfDay? mingguBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (mingguBukaTime != null) {
      _mingguBukaController.text = mingguBukaTime.format(context);
    }
  }

  Future<void> _selectTimeMingguT(BuildContext context) async {
    final TimeOfDay? mingguTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (mingguTutupTime != null) {
      _mingguTutupController.text = mingguTutupTime.format(context);
    }
  }

  //untuk upload image
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
                        value: selectedOptionKategori,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOptionKategori = newValue!;
                          });
                        },
                        items: <String>['air-terjun', 'rekreasi', 'situs']
                            .map<DropdownMenuItem<String>>((String value) {
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
                ],
              ),
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: const Text("Page 2"),
            content: Column(children: [
              Flexible(
                flex: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Operasional',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text('Buka/Tutup',
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Senin',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _senin,
                    onChanged: (value) {
                      setState(() {
                        _seninBukaController.text = '';
                        _seninTutupController.text = '';
                        _senin24Checked = false;
                        _senin = value!;
                      });
                    },
                  ),
                  Visibility(
                      visible: _senin,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _senin24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _senin24Checked = value!;
                                  _seninBukaController.text = '';
                                  _seninTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _senin && !_senin24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _seninBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSeninB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSeninB(context);
                            },
                          ),
                          TextFormField(
                            controller: _seninTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSeninT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSeninT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Selasa',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _selasa,
                    onChanged: (value) {
                      setState(() {
                        _selasaBukaController.text = '';
                        _selasaTutupController.text = '';
                        _selasa24Checked = false;
                        _selasa = value!;
                      });
                    },
                  ),
                  Visibility(
                      visible: _selasa,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _selasa24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _selasa24Checked = value!;
                                  _selasaBukaController.text = '';
                                  _selasaTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _selasa && !_selasa24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _selasaBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSelasaB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSelasaB(context);
                            },
                          ),
                          TextFormField(
                            controller: _selasaTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSelasaT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSelasaT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Rabu',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _rabu,
                    onChanged: (value) {
                      setState(() {
                        _rabuBukaController.text = '';
                        _rabuTutupController.text = '';
                        _rabu = value!;
                        _rabu24Checked = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: _rabu,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _rabu24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _rabu24Checked = value!;
                                  _rabuBukaController.text = '';
                                  _rabuTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _rabu && !_rabu24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _rabuBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeRabuB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeRabuB(context);
                            },
                          ),
                          TextFormField(
                            controller: _rabuTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeRabuT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeRabuT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Kamis',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _kamis,
                    onChanged: (value) {
                      setState(() {
                        _kamisBukaController.text = '';
                        _kamisTutupController.text = '';
                        _kamis = value!;
                        _kamis24Checked = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: _kamis,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _kamis24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _kamis24Checked = value!;
                                  _kamisBukaController.text = '';
                                  _kamisTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _kamis && !_kamis24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _kamisBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeKamisB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeKamisB(context);
                            },
                          ),
                          TextFormField(
                            controller: _kamisTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeKamisT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeKamisT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        "Jum\'at",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _jumat,
                    onChanged: (value) {
                      setState(() {
                        _jumatBukaController.text = '';
                        _jumatTutupController.text = '';
                        _jumat = value!;
                        _jumat24Checked = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: _jumat,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _jumat24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _jumat24Checked = value!;
                                  _jumatBukaController.text = '';
                                  _jumatTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _jumat && !_jumat24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _jumatBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeJumatB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeJumatB(context);
                            },
                          ),
                          TextFormField(
                            controller: _jumatTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeJumatT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeJumatT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Sabtu',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _sabtu,
                    onChanged: (value) {
                      setState(() {
                        _sabtuBukaController.text = '';
                        _sabtuTutupController.text = '';
                        _sabtu = value!;
                        _sabtu24Checked = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: _sabtu,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _sabtu24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _sabtu24Checked = value!;
                                  _sabtuBukaController.text = '';
                                  _sabtuTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _sabtu && !_sabtu24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _sabtuBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSabtuB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSabtuB(context);
                            },
                          ),
                          TextFormField(
                            controller: _sabtuTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeSabtuT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeSabtuT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    activeColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Minggu',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    value: _minggu,
                    onChanged: (value) {
                      setState(() {
                        _mingguBukaController.text = '';
                        _mingguTutupController.text = '';
                        _minggu = value!;
                        _minggu24Checked = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: _minggu,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text('Buka 24 Jam'),
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              value: _minggu24Checked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _minggu24Checked = value!;
                                  _mingguBukaController.text = '';
                                  _mingguTutupController.text = '';
                                });
                              },
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: _minggu && !_minggu24Checked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _mingguBukaController,
                            decoration: InputDecoration(
                              labelText: 'Buka',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeMingguB(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeMingguB(context);
                            },
                          ),
                          TextFormField(
                            controller: _mingguTutupController,
                            decoration: InputDecoration(
                              labelText: 'Tutup',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.access_time),
                                onPressed: () {
                                  _selectTimeMingguT(context);
                                },
                              ),
                            ),
                            readOnly: true,
                            onTap: () {
                              _selectTimeMingguT(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("Penginapan / Camping :",
                      style: TextStyle(fontWeight: FontWeight.w500)),
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
                  const Text("Tutup Sementara :",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(
                    width: 10,
                  ),
                  Switch(
                    value: switchValueTempClosed,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (bool newValue) {
                      setState(() {
                        switchValueTempClosed = newValue;
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
                if (_namaController.text != 'null' ||
                    _descController.text != '' ||
                    _imageUrl != null ||
                    _tiketController.text != "") {
                  saveDataToFirestore();
                  print("Completed");
                }
                print("Gagal");
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
