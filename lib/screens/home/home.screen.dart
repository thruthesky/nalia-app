import 'package:flutter/material.dart';
import 'package:nalia_app/screens/home/home.user_card_slides.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        route: RouteNames.home,
      ),
      body: HomeUserCardSlides(),
    );
  }
}
