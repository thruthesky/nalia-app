import 'package:flutter/material.dart';
import 'package:nalia_app/widgets/custom_app_bar.menu.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  CustomAppBar({@required this.route});
  final String route;
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomAppBarMenu(route: widget.route),
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
    );
  }
}
