import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wite_dashboard/Screen/weatherForecastScreen.dart';

class WeatherScreen extends StatefulWidget {
  // const WeatherScreen({Key? key}) : super(key: key);

  final lat;
  final long;
  final nama;
  const WeatherScreen(
      {required this.lat, required this.long, required this.nama});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool? internetConn;

  var temp;
  var desc;
  var currently;
  var humidity;
  var windSpeed;
  var press;
  var tempMin;
  var tempMax;

  var temp5 = [];
  var desc5 = [];
  var windSpeed5 = [];
  var dt = [];
  var cuaca = [];

  List get _hari {
    List<String> hasil = [];
    if (dt.isNotEmpty) {
      for (var i = 0; i < dt.length; i++) {
        String c = DateFormat('EEEE').format(DateTime.parse(dt[i]));
        switch (c) {
          case 'Monday':
            hasil.add('Senin');
            break;
          case 'Tuesday':
            hasil.add('Selasa');
            break;
          case 'Wednesday':
            hasil.add('Rabu');
            break;
          case 'Thursday':
            hasil.add('Kamis');
            break;
          case 'Friday':
            hasil.add('Jum\'at');
            break;
          case 'Saturday':
            hasil.add('Sabtu');
            break;
          case 'Sunday':
            hasil.add('Minggu');
            break;
          default:
            '';
        }
      }
    }
    return hasil;
  }

  List get _cuacaId {
    List<String> hasil = [];
    if (cuaca.isNotEmpty) {
      for (var i = 0; i < cuaca.length; i++) {
        switch (cuaca[i]) {
          case 'Rain':
            hasil.add('Hujan');
            break;
          case 'Clouds':
            hasil.add('Berawan');
            break;
          case 'Clear':
            hasil.add('Cerah');
            break;
          default:
            '';
        }
      }
    }
    return hasil;
  }

  Widget _cuacaIcons(int value) {
    if (cuaca[value] == 'Rain') {
      return const Icon(FontAwesomeIcons.cloudRain, color: Colors.black);
    } else if (cuaca[value] == 'Clouds') {
      return const Icon(FontAwesomeIcons.cloud, color: Colors.black);
    } else if (cuaca[value] == 'Clear') {
      return const Icon(
        FontAwesomeIcons.solidSun,
        color: Colors.black,
        size: 22,
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Future getWeather(lat, long) async {
    http.Response response = await http.get(Uri.parse(
        // "https://api.openweathermap.org/data/2.5/weather?lat=-6.6400000&lon=106.708000&units=metric&lang=id&appid=dbdeefdb6e461817032cc39199b4cc87"));
        "https://api.openweathermap.org/data/2.5/weather?lat=${lat.toString()}&lon=${long.toString()}&units=metric&lang=id&appid=dbdeefdb6e461817032cc39199b4cc87"));
    var results = jsonDecode(response.body);
    temp = results['main']['temp'];
    desc = results['weather'][0]['description'];
    currently = results['weather'][0]['main'];
    humidity = results['main']['humidity'];
    press = results['main']['pressure'];
    windSpeed = results['wind']['speed'];
    tempMin = results['main']['temp_min'];
    tempMax = results['main']['temp_max'];

    http.Response response2 = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/forecast?lat=${lat.toString()}&lon=${long.toString()}&units=metric&lang=id&appid=dbdeefdb6e461817032cc39199b4cc87"));
    var results2 = jsonDecode(response2.body);
    for (var i = 3; i < results2['list'].length - 25; i++) {
      temp5.add(results2['list'][i]['main']['temp']);
      dt.add(results2['list'][i]['dt_txt']);
      windSpeed5.add(results2['list'][i]['wind']['speed']);
      cuaca.add(results2['list'][i]['weather'][0]['main']);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    internetChecked();
  }

  void internetChecked() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      getWeather(widget.lat, widget.long);
      internetConn = true;
    } else {
      internetConn = false;
      _showSnackBar();
    }
  }

  void _showSnackBar() {
    final snackBar = SnackBar(
      content: const Text('Tidak ada koneksi internet'),
    );
  }

  @override
  Widget build(BuildContext context) {
    String nmr = temp.toString().substring(0, 2);
    String nmrMin = tempMin.toString().substring(0, 2);
    String nmrMax = tempMax.toString().substring(0, 2);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.nama,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.8,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  // color: Theme.of(context).primaryColor,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black26,
                  //     offset: Offset(0, 3),
                  //     blurRadius: 10,
                  //   ),
                  // ],
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(20),
                  //     bottomRight: Radius.circular(20))
                  ),
              child: temp == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black54),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Min $nmrMin\u00B0C  |  Max $nmrMax\u00B0C',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' $nmr',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 50,
                                  fontWeight: FontWeight.w600),
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  temp != null ? '\u00B0' : '',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            Column(
                              children: const [
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'C',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            desc != null
                                ? '${desc[0].toUpperCase()}${desc.substring(1).toLowerCase()}'
                                : '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 7,
                    ),
                  ],
                  // color: Theme.of(context).primaryColor,
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Temperatur',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).accentColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            temp != null ? '$nmr\u00B0' 'C' : 'loading',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Kelembapan',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).accentColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(humidity != null ? "$humidity%" : 'loading',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tekanan',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).accentColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            press != null ? '$press mbar' : 'loading',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Kecepatan angin',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).accentColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                              windSpeed != null ? '$windSpeed km/j' : 'loading',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    internetConn == true ? 'Prakiraan Cuaca' : '',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: () {
                      internetConn == true
                          ? Get.to(const WeatherForecastScreen())
                          : const SnackBar(
                              content: Text('Tidak ada koneksi internet'),
                            );
                    },
                    child: Visibility(
                      visible: internetConn == true ? true : false,
                      child: Container(
                        color: Colors.white,
                        child: const Text(
                          'Selengkapnya',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 70,
            //   child: ListView.builder(
            //     physics: const BouncingScrollPhysics(),
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 5,
            //     itemBuilder: (BuildContext context, int index) {
            //       return Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20),
            //         child: Column(
            //           children: [
            //             Text(
            //               dt.isEmpty
            //                   ? 'loading'
            //                   : '${dt[index].toString().substring(11, 17)} WIB',
            //               style: TextStyle(
            //                   fontSize: 12,
            //                   color: Theme.of(context).accentColor),
            //             ),
            //             const SizedBox(height: 5),
            //             Text(
            //               temp5.isEmpty ? 'loading' : '${temp5[index]}\u00B0C',
            //               style: const TextStyle(
            //                   fontSize: 18, fontWeight: FontWeight.w500),
            //             ),
            //             const SizedBox(height: 5),
            //             Text(
            //               windSpeed5.isEmpty
            //                   ? 'loading'
            //                   : '${windSpeed5[index]} km/j',
            //               style: TextStyle(
            //                   fontSize: 12,
            //                   color: Theme.of(context).accentColor),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // const SizedBox(height: 20),

            Container(
              height: 170,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 5),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: cuaca.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Container(
                        width: 80,
                        height: 140,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        margin: const EdgeInsets.only(
                          left: 15,
                          right: 5,
                        ),
                        decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 2),
                                blurRadius: 7,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              cuaca.isEmpty ? 'loading' : '${_hari[index]}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              cuaca.isEmpty
                                  ? 'loading'
                                  : DateFormat('HH:mm')
                                      .format(DateTime.parse(dt[index])),
                              style: const TextStyle(color: Colors.black),
                            ),
                            cuaca.isEmpty
                                ? Text("Loading")
                                // const SizedBox(
                                //     height: 20,
                                //     width: 20,
                                //     child: CircularProgressIndicator(
                                //       valueColor: AlwaysStoppedAnimation<Color>(
                                //           Colors.black),
                                //     ),
                                //   )
                                : _cuacaIcons(index),
                            Text(
                              cuaca.isEmpty ? 'loading' : '${_cuacaId[index]}',
                              style: const TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            // ListView.builder(
            //     physics: const NeverScrollableScrollPhysics(),
            //     scrollDirection: Axis.vertical,
            //     itemCount: 5,
            //     shrinkWrap: true,
            //     itemBuilder: (BuildContext context, int index) {
            //       return Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 20),
            //           child: Column(
            //             children: [
            //               Container(
            //                 margin: const EdgeInsets.only(bottom: 10),
            //                 decoration: BoxDecoration(
            //                     color: Theme.of(context).primaryColor,
            //                     borderRadius: const BorderRadius.all(
            //                         Radius.circular(20))),
            //                 child: ListTile(
            //                   leading: cuaca.isEmpty
            //                       ? const SizedBox(
            //                           height: 20,
            //                           width: 20,
            //                           child: CircularProgressIndicator(
            //                             valueColor:
            //                                 AlwaysStoppedAnimation<Color>(
            //                                     Colors.white54),
            //                           ),
            //                         )
            //                       : _cuacaIcons(index),
            //                   title: Text(
            //                     cuaca.isEmpty
            //                         ? 'loading'
            //                         // : '${DateFormat('EEEE').format(DateTime.parse(dt[index]))} ⋅ ${cuaca[index]}',
            //                         : '${_hari[index]} ${DateFormat('HH:mm').format(DateTime.parse(dt[index]))} ⋅ ${_cuacaId[index]}',
            //                     style: const TextStyle(color: Colors.white),
            //                   ),
            //                   trailing: temp5.isEmpty
            //                       ? const SizedBox(
            //                           height: 20,
            //                           width: 20,
            //                           child: CircularProgressIndicator(
            //                             valueColor:
            //                                 AlwaysStoppedAnimation<Color>(
            //                                     Colors.white54),
            //                           ),
            //                         )
            //                       : Text(
            //                           '${temp5[index].toString().substring(0, 2)}\u00B0'
            //                           'C',
            //                           style:
            //                               const TextStyle(color: Colors.white),
            //                         ),
            //                 ),
            //               )
            //             ],
            //           ));
            //     })
          ],
        ),
      ),
    );
  }
}
