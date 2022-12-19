import 'package:flutter/material.dart';
import 'package:trade_app/widgets/app_title_homepage.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:trade_app/screens/bookInfo.dart';
import 'package:trade_app/widgets/reusable_widget.dart';
import 'package:trade_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final slide = ImageSlideshow(
    indicatorColor: Colors.white,
    onPageChanged: (value) {
      debugPrint('Page changed: $value');
    },
    autoPlayInterval: 3000,
    isLoop: true,
    children: [
      Image.network(
          "http://books.google.com/books/content?id=-VfNSAAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
      Image.network(
          "http://books.google.com/books/content?id=fltxyAEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api"),
      Image.network(
          "http://books.google.com/books/content?id=T929zgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
    ],
  );
  final slide2 = ImageSlideshow(
    indicatorColor: Colors.white,
    onPageChanged: (value) {
      debugPrint('Page changed: $value');
    },
    autoPlayInterval: 3000,
    isLoop: true,
    children: [
      Image.network(
          "http://books.google.com/books/content?id=gvB1DQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
      Image.network(
          "http://books.google.com/books/content?id=ZRdbmjRjljkC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"),
    ],
  );
  final bm = Text.rich(
    TextSpan(
      text: 'Books of the month! ',

      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      // default text style
    ),
    textAlign: TextAlign.left,
  );
  final heading = Text.rich(
    TextSpan(
      text: 'Our Recommendations! ',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      // default text style
    ),
  );

  final category_text = Text.rich(
    TextSpan(
      text: 'Recommended Categories',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      // default text style
    ),
  );

  @override
  Widget build(BuildContext context) {
    var username = context.watch<UserProvider>().user.name;
    return Scaffold(
      appBar: ReusableWidgets.LoginPageAppBar('Welcome Back! $username'),
      body: Column(
        children: <Widget>[
          SizedBox(height: 70.0),
          bm,
          SizedBox(height: 20.0),
          slide,
          SizedBox(height: 70.0),
          heading,
          SizedBox(height: 20.0),
          slide2,
          SizedBox(height: 20.0),
          //category_text,
        ],
      ),
    );
  }
}
