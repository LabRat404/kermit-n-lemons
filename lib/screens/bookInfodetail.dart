import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:trade_app/widgets/reusable_widget.dart';
//new backup upload image
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

class InfoDetailPage extends StatefulWidget {
  final String isbncode;
  InfoDetailPage({required this.isbncode, Key? key}) : super(key: key);
  static const String routeName = '/bookinfodetail';
  @override
  State<InfoDetailPage> createState() => _InfoDetailPageState();
}

class _InfoDetailPageState extends State<InfoDetailPage> {
  void initState() {
    super.initState();
    readJson();
  }

  List<String> info = [];
  // Fetch content from the json file
  Future<void> readJson() async {
    String isbncodes = widget.isbncode;
    http.Response resa = await http.post(
        //localhost
        //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
        Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
        body: jsonEncode({"book_isbn": isbncodes}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    //load  the json here!!
    //print(res);

    //print("resbody2 -->" + data[0]);
    // print("resbody3 -->" + data['title']);
    //print("resbody4 -->" + data[0]['title']);

    final data2 = await json.decode(resa.body);

    setState(() {
      info.addAll([
        data2["title"],
        data2["subtitle"],
        data2["authors"][0],
        data2["imageLinks"]["smallThumbnail"],
        data2['infoLink'],
        data2['description'],
      ]);
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
            info.isNotEmpty
                ? Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Book title: " + info[0]),
                          subtitle: Text(
                            info[1] +
                                '\n' +
                                "Book author " +
                                info[2] +
                                '\n' +
                                "ISBN code: " +
                                widget.isbncode +
                                '\n' +
                                "Description: " +
                                info[5],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),

                        //Image.network(_items[index]["smallThumbnail"]),
                        Image.network(info[3]),
                        Center(
                            child: ButtonBar(
                          mainAxisSize: MainAxisSize.min,
                          //alignment: Alignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.link),
                              label: Text("Show more on Google Play Book"),
                              onPressed: () async {
                                if (await canLaunchUrl(Uri.parse(info[4]))) {
                                  launchUrl(Uri.parse(info[4]));
                                }
                              },
                            ),
                          ],
                        ))
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Text(
                        'Bring doria back so its not empty here!' +
                            'no books for code: ${widget.isbncode}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Center(
                        child: Image.asset('assets/empty.png'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
