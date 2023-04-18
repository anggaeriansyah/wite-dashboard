import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  // const MyWidget({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Data Wisata",
        ),
        backgroundColor: Colors.yellow.shade700,
        // backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const Center(child: Text('data')),
    );
  }
}
