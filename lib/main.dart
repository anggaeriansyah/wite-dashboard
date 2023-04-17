import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wite_dashboard/Dashboard.dart';
import 'package:wite_dashboard/dashboardScreen.dart';

void main() {
  runApp(const MyApp());
}

Color _colorPrime = HexColor("#1C6758");
Color _colorSec = HexColor("#FFFFFF");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WITE Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: _colorPrime,
      ),
      home: Dashboard(),
    );
  }
}

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF${hex.toUpperCase().replaceAll("#", "")}";
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}
