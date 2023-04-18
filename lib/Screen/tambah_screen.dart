import 'package:flutter/material.dart';

class TambahScreen extends StatefulWidget {
  // const MyWidget({Key? key}) : super(key: key);

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Tambah Data Wisata",
        ),
        backgroundColor: Colors.green,
        // backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const Center(child: Text('data')),
    );
  }
}
