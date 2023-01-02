import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:trade_app/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:trade_app/screens/information_page.dart';
import 'package:trade_app/screens/login_page.dart';
import 'package:trade_app/screens/change_page.dart';
import 'package:trade_app/screens/avatarchange.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

class ShowotherUser extends StatefulWidget {
  final String otherusername;
  const ShowotherUser({required this.otherusername, Key? key})
      : super(key: key);
  static const String routeName = '/showotheruser';
  @override
  State<ShowotherUser> createState() => _ShowotherUserState();
}

class _ShowotherUserState extends State<ShowotherUser> {
  @override
  //String realusername = 'doria';

  void initState() {
    //print("Hi  Im loading");
    super.initState();
    //var realusername = context.watch<UserProvider>().user.name;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   realusername = Provider.of<String>(context, listen: false);
    // });
    String realusername = widget.otherusername;
    readJson(realusername);
    readJson2(realusername);
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
    //print(resaa);
    final data = await json.decode(resaa.body);
    setState(() {
      _items = data;
    });
  }

  String links = "";
  // Fetch content from the json file
  Future<void> readJson2(realusername) async {
    //load  the json here!!
    //fetch here
    print("username is:" + realusername);
    http.Response resaa = await http.get(
        Uri.parse('http://172.20.10.3:3000/api/grabuserdata/$realusername'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    print(resaa);
    final data = await json.decode(resaa.body);
    setState(() {
      links = data["address"];
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
    var username = context.watch<UserProvider>().user.name;
    return Scaffold(
      appBar: ReusableWidgets.LoginPageAppBar("Your Inventory"),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            links.isEmpty
                ? SimpleUserCard(
                    userName: username,
                    userProfilePic: AssetImage("assets/empty.png"),
                  )
                : SimpleUserCard(
                    userName: username,
                    userProfilePic: NetworkImage(links),
                  ),
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
                                title: Text("Book title: " +
                                    _items[index]["booktitle"]),
                                subtitle: Text(
                                  "Book author: " +
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
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.link),
                                    label:
                                        Text("Show more on Google Play Book"),
                                    onPressed: () async {
                                      if (await canLaunchUrl(Uri.parse(
                                          _items[index]["googlelink"]))) {
                                        launchUrl(Uri.parse(
                                            _items[index]["googlelink"]));
                                      }
                                      //print(_items[index]["googlelink"]);
                                    },
                                  ),
                                ],
                              )
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
                        'Bring doria back so its not empty here!',
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
