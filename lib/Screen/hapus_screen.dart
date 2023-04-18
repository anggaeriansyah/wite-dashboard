import 'package:flutter/material.dart';

class HapusScreen extends StatefulWidget {
  // const MyWidget({Key? key}) : super(key: key);

  @override
  State<HapusScreen> createState() => _HapusScreenState();
}

class _HapusScreenState extends State<HapusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Hapus Data Wisata",
        ),
        backgroundColor: Colors.red,
        // backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const Center(child: Text('data')),
    );
  }
}
