import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:trade_app/widgets/reusable_widget.dart';

class InfoDetailPage extends StatefulWidget {
  const InfoDetailPage({Key? key}) : super(key: key);
  static const String routeName = '/bookinfodetail';
  @override
  State<InfoDetailPage> createState() => _InfoDetailPageState();
}

class _InfoDetailPageState extends State<InfoDetailPage> {
  void initState() {
    super.initState();
    readJson();
  }

  List _items = [];
  // Fetch content from the json file
  Future<void> readJson() async {
    //load  the json here!!
    final String response =
        await rootBundle.loadString('assets/singledata.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableWidgets.LoginPageAppBar('Book Detailed Info'),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            //auto load
            // ElevatedButton(
            //   onPressed: readJson,
            //   child: const Text('Load Book (gets data from json)'),
            // ),

            // Display the data loaded from sample.json
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                    "Book Name: " + _items[index]["title"]),
                                subtitle: Text(
                                  "Subtitle: " +
                                      _items[index]["subtitle"] +
                                      "Authors: " +
                                      _items[index]["authors"][0] +
                                      "\n" +
                                      "Descriptions: " +
                                      _items[index]["description"] +
                                      "\n" +
                                      "ISBN: " +
                                      _items[index]["industryIdentifiers"][0]
                                          ["identifier"],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),

                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                              ),
                              //Image.network(_items[index]["smallThumbnail"]),
                              Image.network(_items[index]["imageLinks"]
                                  ["smallThumbnail"]),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
