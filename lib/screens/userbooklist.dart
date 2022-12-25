import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:trade_app/services/auth/connector.dart';
import 'package:trade_app/screens/bookInfodetail.dart';
import 'package:url_launcher/url_launcher.dart';

class ISBN_info {
  final String title;
  final String publishedDate;

  ISBN_info({required this.title, required this.publishedDate});

  factory ISBN_info.fromJson(Map<String, dynamic> json) {
    final title = json['subtitle'] as String;
    final publishedDate = json['publishedDate'] as String;
    return ISBN_info(title: title, publishedDate: publishedDate);
  }
}

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);
  static const String routeName = '/bookinfo';
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  //String realusername = 'doria';

  void initState() {
    super.initState();
    //var realusername = context.watch<UserProvider>().user.name;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   realusername = Provider.of<String>(context, listen: false);
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final help = Provider.of<UserProvider>(context, listen: false);
      String realusername = help.user.name;
      readJson(realusername);
    });
  }

  // void didChangeDependencies() {
  //   debugPrint(
  //       'Child widget: didChangeDependencies(), counter = $realusername');
  //   super.didChangeDependencies();
  // }

  List _items = [];
  // Fetch content from the json file
  Future<void> readJson(realusername) async {
    //load  the json here!!
    //fetch here
    http.Response resaa = await http.get(
        Uri.parse('http://172.20.10.3:3000/api/grabuserlist/$realusername'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    print(resaa);
    final data = await json.decode(resaa.body);
    setState(() {
      _items = data;
    });
  }

  // getdata(dbisbn) async {
  //   var res = await http.post(
  //       //localhost
  //       //Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
  //       Uri.parse('http://172.20.10.3:3000/api/bookinfo'),
  //       body: jsonEncode({"book_isbn": 0984782869}),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       });
  //   var resBody = json.decode(res.toString());
  //   debugPrint(resBody['title']); // can print title
  //   print(resBody['title']);
  //   return "asdasdsad";
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'book info',
        ),
      ),
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
                                title: Text("Posted by user: " +
                                    _items[index]["username"]),
                                subtitle: Text(
                                  "Book title: " +
                                      _items[index]["booktitle"] +
                                      '\n' +
                                      "Book author " +
                                      _items[index]["author"] +
                                      '\n' +
                                      "ISBN code: " +
                                      _items[index]["dbISBN"],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),

                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                              ),
                              //Image.network(_items[index]["smallThumbnail"]),
                              Image.network(_items[index]["url"]),

                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  _items[index]["comments"],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              ButtonBar(
                                children: [
                                  ElevatedButton(
                                    child: Text("Remove Item"),
                                    onPressed: () {
                                      (context as Element).reassemble();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shadowColor: Colors.orange,
                                    ),
                                  ),
                                  ElevatedButton(
                                    child:
                                        Text("Show book on Google Play Books"),
                                    onPressed: () {},
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                        return ButtonBar();
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
