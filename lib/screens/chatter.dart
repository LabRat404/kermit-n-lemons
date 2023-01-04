import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:audioplayers/audioplayers.dart';
import "package:cached_network_image/cached_network_image.dart";
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

class Chatter extends StatefulWidget {
  final String title;
  Chatter({Key? key, required this.title}) : super(key: key);

  @override
  _ChatterState createState() => _ChatterState();
}

class _ChatterState extends State<Chatter> {
  void initState() {
    super.initState();
    readJson();
  }

  var data2;

  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    //load  the json here!!
    //fetch here

    final String response = await rootBundle.loadString('assets/chatter.json');
    // final data = await json.decode(response);
    // http.Response resaa = await http.get(
    //     Uri.parse('http://172.20.10.3:3000/api/grabuserlist/tangjaii'),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     });
    // print(resaa);

    final data = await json.decode(response);

    setState(() {
      // _items = data["items"];
      // _items = data;
      //data2 = data;
      data2 = data;
    });
    print(data);
    print("compare\n");
    print(data2);
    data2["chats"].forEach((value) {
      value["chatter"].forEach((userchat) {
        if (userchat["user"] == "tanjaii") {
          print(userchat["text"].toString());
        }
      });
    });
  }

  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;

  // printchat() {
  //   return
  // }
  int j = 0;

  printchat(int i, int j) {}

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BubbleNormalImage(
                  id: 'id001',
                  image: _image(),
                  color: Colors.purpleAccent,
                  tail: true,
                  delivered: true,
                ),
                //printchat(),data2["chats"].forEach((value) {
                //   value["chatter"].forEach((userchat) {
                //     if (userchat["user"] == "tanjaii") {
                //       print(userchat["text"].toString());
                //     }
                //   });
                // });

                for (int i = 0; i < data2["chats"].length; i++)
                  for (j = 0; j < data2["chats"][i]["chatter"].length; j++)
                    if (data2["chats"][i]["chatter"][j]["user"] == "tanjaii")
                      BubbleSpecialOne(
                        text:
                            data2["chats"][i]["chatter"][j]["text"].toString(),
                        isSender: false,
                        color: Colors.black,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )
                    else
                      BubbleSpecialOne(
                        text:
                            data2["chats"][i]["chatter"][j]["text"].toString(),
                        isSender: true,
                        color: Color(0xFF1B97F3),
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),

                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
          MessageBar(
            onSend: (_) => print(_),
            actions: [
              InkWell(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: () {},
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                    size: 24,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _image() {
    return Container(
      constraints: BoxConstraints(
        minHeight: 20.0,
        minWidth: 20.0,
      ),
      child: CachedNetworkImage(
        imageUrl: 'https://i.ibb.co/JCyT1kT/Asset-1.png',
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(new Duration(seconds: value.toInt()));
    });
  }

  void _playAudio() async {
    final url =
        'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3';
    if (isPause) {
      await audioPlayer.resume();
      setState(() {
        isPlaying = true;
        isPause = false;
      });
    } else if (isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isPause = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
        isLoading = false;
      });
    });
  }
}
