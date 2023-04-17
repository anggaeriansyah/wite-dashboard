import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  // const MyWidget({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Dashboard",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          // backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 70,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Manage data wisata',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 10,
                            color: Colors.black12,
                            // spreadRadius: 0.5,
                          )
                        ]),
                    child: const Icon(Icons.add_box_rounded),
                  ),
                  Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width * 0.42,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 10,
                              color: Colors.black12,
                              // spreadRadius: 0.5,
                            )
                          ]),
                      child: const Icon(Icons.edit)),
                ],
              ),
            ),
            // Flexible(
            //     child: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     children: [
            //       Container(
            //         color: Colors.amber,
            //         child: const ListTile(
            //           leading: Icon(Icons.add_box),
            //           title: Text(
            //             'Tambah data wisata',
            //             style: TextStyle(
            //                 fontSize: 16, fontWeight: FontWeight.w500),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 5),
            //       Container(
            //         color: Colors.amber,
            //         child: const ListTile(
            //           leading: Icon(Icons.edit),
            //           title: Text('Edit data wisata'),
            //         ),
            //       ),
            //       const SizedBox(height: 5),
            //       Container(
            //         color: Colors.amber,
            //         child: const ListTile(
            //           leading: Icon(Icons.delete),
            //           title: Text('Hapus data wisata'),
            //         ),
            //       ),
            //     ],
            //   ),
            // )),
          ],
        ));
  }
}
