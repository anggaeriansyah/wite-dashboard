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
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 10,
                                color: Colors.black12,
                                // spreadRadius: 0.5,
                              )
                            ]),
                      ),
                      const Positioned(
                          top: 15,
                          right: 15,
                          child: Icon(
                            Icons.add_box_rounded,
                            size: 30,
                            color: Colors.white,
                          )),
                      Positioned(
                        bottom: 0,
                        child: Container(
                            // color: Colors.amber,
                            width: MediaQuery.of(context).size.width * 0.42,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: const Text(
                              '''Tambah
data wisata''',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              maxLines: 2,
                            )),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            color: Colors.yellow.shade700,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 10,
                                color: Colors.black12,
                                // spreadRadius: 0.5,
                              )
                            ]),
                      ),
                      const Positioned(
                          top: 15,
                          right: 15,
                          child: Icon(
                            Icons.edit,
                            size: 30,
                            color: Colors.white,
                          )),
                      Positioned(
                        bottom: 0,
                        child: Container(
                            // color: Colors.amber,
                            width: MediaQuery.of(context).size.width * 0.42,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: const Text(
                              '''Edit
data wisata''',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              maxLines: 2,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 10,
                                color: Colors.black12,
                                // spreadRadius: 0.5,
                              )
                            ]),
                      ),
                      const Positioned(
                          top: 15,
                          right: 15,
                          child: Icon(
                            Icons.delete,
                            size: 30,
                            color: Colors.white,
                          )),
                      Positioned(
                        bottom: 0,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.42,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: const Text(
                              '''Hapus
data wisata''',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              maxLines: 2,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              indent: 20,
              endIndent: 20,
              thickness: 2,
            ),
            Flexible(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Container(
                    color: Colors.amber,
                    child: const ListTile(
                      leading: Icon(Icons.add_box),
                      title: Text(
                        'Tambah data wisata',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    color: Colors.amber,
                    child: const ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit data wisata'),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    color: Colors.amber,
                    child: const ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Hapus data wisata'),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ));
  }
}
