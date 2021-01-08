import 'package:flutter/material.dart';
import 'package:nalia_app/services/defines.dart';

class LoginFirst extends StatefulWidget {
  @override
  _LoginFirstState createState() => _LoginFirstState();
}

class _LoginFirstState extends State<LoginFirst> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          spaceXxl,
          Container(
            child: Text('Login first!!'),
          ),
        ],
      ),
    );
  }
}
