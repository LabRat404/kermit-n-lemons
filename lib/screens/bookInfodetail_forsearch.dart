import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:trade_app/widgets/reusable_widget.dart';
//new backup upload image
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';

class InfoDetailPageSearch extends StatefulWidget {
  final String hashname;
  InfoDetailPageSearch({required this.hashname, Key? key}) : super(key: key);
  static const String routeName = '/bookinfodetailsearch';
  @override
  State<InfoDetailPageSearch> createState() => _InfoDetailPageSearchState();
}

class _InfoDetailPageSearchState extends State<InfoDetailPageSearch> {
  void initState() {
    super.initState();
    readJson();
  }

  List<String> info = [];
  // Fetch content from the json file
  Future<void> readJson() async {
    String hashname = widget.hashname;
    http.Response resa = await http.get(
        //localhost
        //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
        Uri.parse('http://172.20.10.3:3000/api/grabdbbook/$hashname'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    //load  the json here!!
    //print(res);

    //print("resbody2 -->" + data[0]);
    // print("resbody3 -->" + data['title']);
    //print("resbody4 -->" + data[0]['title']);

    final data2 = await json.decode(resa.body);
    String btitle = "Not found";
    String bsubtitle = "Not found";
    String blink = "Not found";
    String bauthors = "Not found";
    String binfoLink = "Not found";
    String bdescription = "Not found";
    String postby = "Not found";
    print("asdsadsadsad" + postby);
    print("data name is" + data2[0]["name"]);
    // if (data2["name"] != null) btitle = data2["name"].toString();
    // if (data2["name"] != null) bsubtitle = data2["name"].toString();
    // if (data2["name"] != null) bauthors = data2["name"].toString();
    // if (data2["name"] != null) binfoLink = data2["name"].toString();
    // if (data2["name"] != null) postby = data2["name"].toString();
    // if (data2["name"] != null) bdescription = data2["name"].toString();
    // if (data2["name"] != null) blink = data2["name"].toString();

    setState(() {
      info.addAll([
        btitle,
        bsubtitle,
        bauthors,
        blink,
        binfoLink,
        bdescription,
        postby
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
            if (info.isNotEmpty)
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    (info[3] == "Not found")
                        ? Image.asset('assets/empty.png')
                        : Image.network(info[3]),
                    ListTile(
                      title: Text("Book title: " + info[0]),
                      subtitle: Text(
                        "Subtitle: " +
                            info[1] +
                            '\n' +
                            "Book author " +
                            info[2] +
                            '\n' +
                            "ISBN code: " +
                            widget.hashname +
                            '\n' +
                            "Description: " +
                            info[5],
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),

                    //Image.network(_items[index]["smallThumbnail"]),

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
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Text(
                    'Bring doria back so its not empty here!' +
                        'no books for code: ${widget.hashname}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
