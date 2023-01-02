import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_app/screens/userbooklist.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:provider/provider.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:trade_app/widgets/nav_bar.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = '/Search';
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  //String realusername = 'doria';

  void initState() {
    //print("Hi  Im loading");
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

  List _items = [];
  Future<void> readJson(realusername) async {
    //load  the json here!!
    //fetch here
    http.Response resaa = await http.get(
        Uri.parse('http://172.20.10.3:3000/api/graballuserbook'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    print(resaa);
    final data = await json.decode(resaa.body);
    setState(() {
      _items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for a book!',
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0.9,
                    fontSize: 25))),
        flexibleSpace: Image(
          image: AssetImage('assets/book_title.jpg'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search, size: 35),
          ),
        ],
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
                                title: Text(_items[index]["booktitle"]),
                                subtitle: Text(
                                  "Posted by user: " +
                                      _items[index]["username"] +
                                      '\n' +
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
                                    icon: Icon(Icons.recycling),
                                    label: Text("Trade with user " +
                                        _items[index]["username"]),
                                    onPressed: () async {
                                      print("Trade!");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shadowColor: Colors.orange,
                                    ),
                                  ),
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
                                      print(_items[index]["googlelink"]);
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

class CustomSearchDelegate extends SearchDelegate {
  List<String> seacrhTerms = [
    'Atomic Habits',
    'Cracking the Coding Interview, Fourth Edition Book 1',
    'The Last Wish',
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          print("hi");
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in seacrhTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in seacrhTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase()))
        matchQuery.add(fruit);
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          subtitle: Text(
            "Asddsad",
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserList(),
              ),
            );
          },
        );
      },
    );
  }
}
