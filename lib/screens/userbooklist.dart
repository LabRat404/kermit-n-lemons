import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/services/auth/connector.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trade_app/widgets/nav_bar.dart';
import '../../constants/error_handling.dart';
import 'package:trade_app/screens/login_page.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);
  static const String routeName = '/bookinfo';
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  String realusername = '';

  void initState() {
    super.initState();
    //realusername = Provider.of<String>(context, listen: false);
    //print(realusername);
    readJson();
  }

  // void didChangeDependencies() {
  //   debugPrint(
  //       'Child widget: didChangeDependencies(), counter = $realusername');
  //   super.didChangeDependencies();
  // }

  List _items = [];
  // Fetch content from the json file
  Future<void> readJson() async {
    //load  the json here!!
    //fetch here
    http.Response resaa = await http.get(
        Uri.parse('http://172.20.10.3:3000/api/grabuserlist/tangjaii'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    print(resaa);
    final data = await json.decode(resaa.body);
    print(data[0]["username"] + "asdsadsadasdlolz");
    setState(() {
      _items = data;
    });
  }

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
                                  "ISBN code: " + _items[index]["dbISBN"],
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
