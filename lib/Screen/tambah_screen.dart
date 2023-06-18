import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wite_dashboard/Screen/Dashboard.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TambahScreen extends StatefulWidget {
  // const MyWidget({Key? key}) : super(key: key);

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  // final _formKey = GlobalKey<FormState>();
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};
  final picker = ImagePicker();
  final picker1 = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseStorage storage1 = FirebaseStorage.instance;
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
  List<String>? downloadUrls;
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

  //validasi form
  bool _isNamaEmpty = false;
  bool _isTiketEmpty = false;

  void validateNama(value) {
    setState(() {
      _isNamaEmpty = _namaController.text.isEmpty || value == '';
    });
  }

  void validateTiket(value) {
    setState(() {
      _isTiketEmpty = _tiketController.text.isEmpty || value == '';
    });
  }

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
      "desa": selectedOptionDesa,
      "kec": "Kecamatan Tenjolaya",
      "tiket": int.parse(_tiketController.text),
      "desc": _descController.text,
      "tempClosed": switchValueTempClosed,
      "penginapan": switchValueCamp,
      "kategori": selectedOptionKategori,
      "hariOp": [_senin, _selasa, _rabu, _kamis, _jumat, _sabtu, _minggu],
      "jamOp": [
        _senin
            ? _senin24Checked
                ? "Buka 24 jam"
                : '${_seninBukaController.text} - ${_seninTutupController.text}'
            : 'Tutup',
        _selasa
            ? _selasa24Checked
                ? "Buka 24 jam"
                : '${_selasaBukaController.text} - ${_selasaTutupController.text}'
            : 'Tutup',
        _rabu
            ? _rabu24Checked
                ? "Buka 24 jam"
                : '${_rabuBukaController.text} - ${_rabuTutupController.text}'
            : 'Tutup',
        _kamis
            ? _kamis24Checked
                ? "Buka 24 jam"
                : '${_kamisBukaController.text} - ${_kamisTutupController.text}'
            : 'Tutup',
        _jumat
            ? _jumat24Checked
                ? "Buka 24 jam"
                : '${_jumatBukaController.text} - ${_jumatTutupController.text}'
            : 'Tutup',
        _sabtu
            ? _sabtu24Checked
                ? "Buka 24 jam"
                : '${_sabtuBukaController.text} - ${_sabtuTutupController.text}'
            : 'Tutup',
        _minggu
            ? _minggu24Checked
                ? "Buka 24 jam"
                : '${_mingguBukaController.text} - ${_mingguTutupController.text}'
            : 'Tutup',
      ],
      "imageGaleries": downloadUrls == null ? [] : downloadUrls,
      "latitude": _selectedLocation!.latitude,
      "longitude": _selectedLocation!.longitude,
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

  Future<List<String>> uploadImagesToFirebase(List<XFile> imageFiles) async {
    List<String> _downloadUrls = [];

    // Mendapatkan referensi ke Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('images');

    // Mengunggah setiap gambar ke Firebase Storage
    for (var imageFile in imageFiles) {
      // Mendapatkan nama unik untuk file gambar
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Mengupload gambar ke Firebase Storage
      final uploadTask =
          storageRef.child(fileName).putFile(File(imageFile.path));

      // Menunggu penyelesaian upload
      final TaskSnapshot snapshot = await uploadTask;

      // Mengambil URL download gambar
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Menambahkan URL download ke dalam list
      _downloadUrls.add(downloadUrl);
    }

    // Mengembalikan list URL download gambar
    return _downloadUrls;
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
      setState(() {
        _seninBukaController.text = seninBukaTime.format(context);
      });
    }
  }

  Future<void> _selectTimeSeninT(BuildContext context) async {
    final TimeOfDay? seninTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: true), // Set format 24 jam
          child: child!,
        );
      },
    );

    if (seninTutupTime != null) {
      _seninTutupController.text = seninTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeSelasaB(BuildContext context) async {
    final TimeOfDay? selasaBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selasaBukaTime != null) {
      _selasaBukaController.text = selasaBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeSelasaT(BuildContext context) async {
    final TimeOfDay? selasaTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selasaTutupTime != null) {
      _selasaTutupController.text = selasaTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeRabuB(BuildContext context) async {
    final TimeOfDay? rabuBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (rabuBukaTime != null) {
      _rabuBukaController.text = rabuBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeRabuT(BuildContext context) async {
    final TimeOfDay? rabuTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (rabuTutupTime != null) {
      _rabuTutupController.text = rabuTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeKamisB(BuildContext context) async {
    final TimeOfDay? kamisBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (kamisBukaTime != null) {
      _kamisBukaController.text = kamisBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeKamisT(BuildContext context) async {
    final TimeOfDay? kamisTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (kamisTutupTime != null) {
      _kamisTutupController.text = kamisTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeJumatB(BuildContext context) async {
    final TimeOfDay? jumatBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (jumatBukaTime != null) {
      _jumatBukaController.text = jumatBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeJumatT(BuildContext context) async {
    final TimeOfDay? jumatTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (jumatTutupTime != null) {
      _jumatTutupController.text = jumatTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeSabtuB(BuildContext context) async {
    final TimeOfDay? sabtuBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (sabtuBukaTime != null) {
      _sabtuBukaController.text = sabtuBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeSabtuT(BuildContext context) async {
    final TimeOfDay? sabtuTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (sabtuTutupTime != null) {
      _sabtuTutupController.text = sabtuTutupTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeMingguB(BuildContext context) async {
    final TimeOfDay? mingguBukaTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (mingguBukaTime != null) {
      _mingguBukaController.text = mingguBukaTime.format(context);
      setState(() {});
    }
  }

  Future<void> _selectTimeMingguT(BuildContext context) async {
    final TimeOfDay? mingguTutupTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (mingguTutupTime != null) {
      _mingguTutupController.text = mingguTutupTime.format(context);
      setState(() {});
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
            title: const Text("Page 1"),
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
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) {
                                    return child;
                                  }
                                  return const CircularProgressIndicator();
                                },
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
                    onChanged: validateNama,
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: "Nama Wisata",
                      errorText: _isNamaEmpty
                          ? 'Nama wisata tidak boleh kosong'
                          : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10),
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
                          'Gunung Mulya',
                          'Situ Daun',
                          'Cinangneng',
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // GoogleMap(
                  //   onMapCreated: (controller) {
                  //     _mapController = controller;
                  //   },
                  //   onTap: (LatLng latLng) {
                  //     setState(() {
                  //       _selectedLocation = latLng;
                  //     });
                  //   },
                  //   initialCameraPosition: CameraPosition(
                  //     target: LatLng(0, 0), // Koordinat awal peta
                  //     zoom: 15, // Tingkat zoom awal
                  //   ),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Proses saat tombol ditekan
                  //     if (_selectedLocation != null) {
                  //       // Lakukan sesuatu dengan _selectedLocation
                  //       print(
                  //           'Lokasi terpilih: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}');
                  //     } else {
                  //       // Tampilkan pesan kesalahan jika lokasi belum dipilih
                  //       showDialog(
                  //         context: context,
                  //         builder: (BuildContext context) {
                  //           return AlertDialog(
                  //             title: Text('Kesalahan'),
                  //             content:
                  //                 Text('Silakan pilih lokasi terlebih dahulu.'),
                  //             actions: [
                  //               TextButton(
                  //                 child: Text('OK'),
                  //                 onPressed: () {
                  //                   Navigator.pop(context);
                  //                 },
                  //               ),
                  //             ],
                  //           );
                  //         },
                  //       );
                  //     }
                  //   },
                  //   child: Text('Simpan'),
                  // ),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
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
                            const Text('Buka 24 Jam'),
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
                                icon: const Icon(Icons.access_time),
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
                                icon: const Icon(Icons.access_time),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
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
                            const Text('Buka 24 Jam'),
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
                                icon: const Icon(Icons.access_time),
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
                                icon: const Icon(Icons.access_time),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
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
                            const Text('Buka 24 Jam'),
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
                                icon: const Icon(Icons.access_time),
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
                                icon: const Icon(Icons.access_time),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
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
                            const Text('Buka 24 Jam'),
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
                                icon: const Icon(Icons.access_time),
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
                                icon: const Icon(Icons.access_time),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
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
                            const Text('Buka 24 Jam'),
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
                                icon: const Icon(Icons.access_time),
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
                                icon: const Icon(Icons.access_time),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
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
                            const Text('Buka 24 Jam'),
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
                                icon: const Icon(Icons.access_time),
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
                                icon: const Icon(Icons.access_time),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
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
                            const Text('Buka 24 Jam'),
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
                                icon: const Icon(Icons.access_time),
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
                                icon: const Icon(Icons.access_time),
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
            content:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text("Galeri :",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      List<XFile> selectedImages =
                          await ImagePicker().pickMultiImage();

                      if (selectedImages.isNotEmpty) {
                        var urls = await uploadImagesToFirebase(selectedImages);
                        setState(() {
                          downloadUrls = urls;
                        });

                        // Lakukan sesuatu dengan URL download gambar
                        // Misalnya, simpan URL ke database atau tampilkan di UI
                      }
                    },
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: const [
                          Icon(
                            Iconsax.add,
                            color: Colors.white,
                          ),
                          Text("Tambah",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              downloadUrls == null
                  ? const SizedBox()
                  : Container(
                      height: 100, // Atur tinggi sesuai kebutuhan
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            downloadUrls!.length, // Jumlah gambar dalam galeri
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Image.network(
                                  downloadUrls![index],
                                  height: 50,
                                  width: 150, // Atur lebar sesuai kebutuhan
                                  fit: BoxFit.cover,
                                ),
                              ));
                        },
                      ),
                    ),
              const SizedBox(height: 10),
              TextFormField(
                onChanged: validateTiket,
                controller: _tiketController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Tiket",
                  errorText:
                      _isNamaEmpty ? 'Nama wisata tidak boleh kosong' : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 10),
                ),
              ),
              // height: 200,
              // width: MediaQuery.of(context).size.width,
              const SizedBox(height: 10),
              Expanded(
                flex: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: GoogleMap(
                      zoomGesturesEnabled: true,
                      onCameraMove: (controller) {
                        _mapController = controller as GoogleMapController;
                      },
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      gestureRecognizers: Set()
                        ..add(Factory<PanGestureRecognizer>(
                            () => PanGestureRecognizer())),
                      onTap: (LatLng latLng) {
                        setState(() {
                          _selectedLocation = latLng;
                          _markers
                              .clear(); // Hapus marker sebelumnya (jika ada)
                          _markers.add(
                            Marker(
                              markerId: const MarkerId('selected_location'),
                              position: _selectedLocation!,
                            ),
                          );
                        });
                      },
                      markers: _markers,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(
                            -6.6400000, 106.708000), // Koordinat awal peta
                        zoom: 15, // Tingkat zoom awal
                      ),
                    ),
                  ),
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
              ),
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
          actions: [
            GestureDetector(
                onTap: () {
                  if (_namaController.text.isNotEmpty &&
                      _tiketController.text.isNotEmpty &&
                      _selectedLocation?.latitude != null &&
                      _selectedLocation?.longitude != null &&
                      _imageUrl != null &&
                      (!_senin ||
                          (_senin24Checked ||
                              (_seninBukaController.text.isNotEmpty &&
                                  _seninTutupController.text.isNotEmpty))) &&
                      (!_selasa ||
                          (_selasa24Checked ||
                              (_selasaBukaController.text.isNotEmpty &&
                                  _selasaTutupController.text.isNotEmpty))) &&
                      (!_rabu ||
                          (_rabu24Checked ||
                              (_rabuBukaController.text.isNotEmpty &&
                                  _rabuTutupController.text.isNotEmpty))) &&
                      (!_kamis ||
                          (_kamis24Checked ||
                              (_kamisBukaController.text.isNotEmpty &&
                                  _kamisTutupController.text.isNotEmpty))) &&
                      (!_jumat ||
                          (_jumat24Checked ||
                              (_jumatBukaController.text.isNotEmpty &&
                                  _jumatTutupController.text.isNotEmpty))) &&
                      (!_sabtu ||
                          (_sabtu24Checked ||
                              (_sabtuBukaController.text.isNotEmpty &&
                                  _sabtuTutupController.text.isNotEmpty))) &&
                      (!_minggu ||
                          (_minggu24Checked ||
                              (_mingguBukaController.text.isNotEmpty &&
                                  _mingguTutupController.text.isNotEmpty)))) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding:
                              const EdgeInsets.fromLTRB(24.0, 15, 24.0, 10),
                          actionsPadding:
                              const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          title: const Text('Perhatian!'),
                          content: const Text(
                            'Apakah anda yakin ingin menyimpan wisata ini?',
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: <Widget>[
                            const Divider(
                              thickness: 1,
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: const Text(
                                        'Simpan',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  onPressed: () {
                                    saveDataToFirestore();
                                    Get.to(Dashboard());
                                    print("Completed");
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Kembali'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Data tidak lengkap'),
                          content: const Text('lengkapi data terlebih dahulu'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: _namaController.text.isNotEmpty &&
                        _tiketController.text.isNotEmpty &&
                        _selectedLocation?.latitude != null &&
                        _selectedLocation?.longitude != null &&
                        _imageUrl != null &&
                        (!_senin ||
                            (_senin24Checked ||
                                (_seninBukaController.text.isNotEmpty &&
                                    _seninTutupController.text.isNotEmpty))) &&
                        (!_selasa ||
                            (_selasa24Checked ||
                                (_selasaBukaController.text.isNotEmpty &&
                                    _selasaTutupController.text.isNotEmpty))) &&
                        (!_rabu ||
                            (_rabu24Checked ||
                                (_rabuBukaController.text.isNotEmpty &&
                                    _rabuTutupController.text.isNotEmpty))) &&
                        (!_kamis ||
                            (_kamis24Checked ||
                                (_kamisBukaController.text.isNotEmpty &&
                                    _kamisTutupController.text.isNotEmpty))) &&
                        (!_jumat ||
                            (_jumat24Checked ||
                                (_jumatBukaController.text.isNotEmpty &&
                                    _jumatTutupController.text.isNotEmpty))) &&
                        (!_sabtu ||
                            (_sabtu24Checked ||
                                (_sabtuBukaController.text.isNotEmpty &&
                                    _sabtuTutupController.text.isNotEmpty))) &&
                        (!_minggu ||
                            (_minggu24Checked ||
                                (_mingguBukaController.text.isNotEmpty &&
                                    _mingguTutupController.text.isNotEmpty)))
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.save,
                          color: Colors.grey,
                        ),
                      ))
          ],
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
                if (_namaController.text.isNotEmpty &&
                    _tiketController.text.isNotEmpty &&
                    _selectedLocation?.latitude != null &&
                    _selectedLocation?.longitude != null &&
                    _imageUrl != null &&
                    (!_senin ||
                        (_senin24Checked ||
                            (_seninBukaController.text.isNotEmpty &&
                                _seninTutupController.text.isNotEmpty)))) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding:
                            const EdgeInsets.fromLTRB(24.0, 15, 24.0, 10),
                        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        title: const Text('Perhatian!'),
                        content: const Text(
                          'Apakah anda yakin ingin menyimpan wisata ini?',
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: <Widget>[
                          const Divider(
                            thickness: 1,
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: const Text(
                                      'Simpan',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                onPressed: () {
                                  saveDataToFirestore();
                                  Get.to(Dashboard());
                                  print("Completed");
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                ),
                                child: const Text('Kembali'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Data tidak lengkap'),
                        content: const Text('lengkapi data terlebih dahulu'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
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
