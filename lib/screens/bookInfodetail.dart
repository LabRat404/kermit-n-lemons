import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
//new backup upload image

import 'package:flutter/material.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:trade_app/screens/bookInfodetail.dart';
import '/../widgets/camera.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:trade_app/widgets/nav_bar.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/services/auth/connector.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:trade_app/services/auth/connector.dart';
import 'package:trade_app/screens/bookInfodetail.dart';

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

  List _items = [];
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
    final String response = await rootBundle.loadString('assets/data.json');
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
                                title: Text(_items[index]["title"]),
                                subtitle: Text(
                                  _items[index]["subtitle"],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  _items[index]["authors"][0],
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
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Text(
                        'Bring doria back so its not empty here!' +
                            _items.toString(),
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
