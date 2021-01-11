import 'package:flutter/material.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';

class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  bool loggedIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.myJewelry),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        child: Column(
          children: [
            Text('User search'),
            Wrap(
              children: [
                // DropdownButton(items: [
                //   DropdownMenuItem()
                // ],)
              ],
            )
          ],
        ),
      ),
    );
  }
}
