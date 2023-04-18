import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //setting the expansion function for the navigation rail
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
              extended: isExpanded,
              backgroundColor: Theme.of(context).primaryColor,
              unselectedIconTheme:
                  const IconThemeData(color: Colors.white, opacity: 1),
              unselectedLabelTextStyle: const TextStyle(
                color: Colors.white,
              ),
              selectedIconTheme: const IconThemeData(color: Colors.green),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text("Home"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add_box_rounded),
                  label: Text("Input data"),
                ),
              ],
              selectedIndex: 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 60, right: 60, bottom: 60),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        const Image(
                          image: AssetImage('images/wite-g.png'),
                          fit: BoxFit.fill,
                          height: 100,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Data Wisata",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "30 data",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Cari wisata",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),

                    //let's set the filter section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            DropdownButton(
                                hint: const Text("Order by"),
                                items: const [
                                  DropdownMenuItem(
                                    value: "ascending",
                                    child: Text("A-Z"),
                                  ),
                                  DropdownMenuItem(
                                    value: "descending",
                                    child: Text("Z-A"),
                                  ),
                                ],
                                onChanged: (value) {}),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    //Now let's add the Table
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DataTable(
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.grey.shade200),
                            columns: const [
                              DataColumn(label: Text("ID")),
                              DataColumn(label: Text("Nama")),
                              DataColumn(label: Text("Desa")),
                              DataColumn(label: Text("Kecamatan")),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text("0")),
                                DataCell(
                                    Text("How to build a Flutter Web App")),
                                DataCell(Text("${DateTime.now()}")),
                                DataCell(Text("2.3K Views")),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("1")),
                                DataCell(
                                    Text("How to build a Flutter Mobile App")),
                                DataCell(Text("${DateTime.now()}")),
                                DataCell(Text("21.3K Views")),
                              ]),
                              DataRow(cells: [
                                DataCell(Text("2")),
                                DataCell(
                                    Text("Flutter for your first project")),
                                DataCell(Text("${DateTime.now()}")),
                                DataCell(Text("2.3M Views")),
                              ]),
                            ]),
                        //Now let's set the pagination
                        const SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "1",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "2",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "3",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "See All",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      //let's add the floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple.shade400,
      ),
    );
  }
}
