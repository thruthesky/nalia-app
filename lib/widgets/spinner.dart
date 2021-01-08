import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({
    Key key,
    this.size = 24,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    final spinner = SizedBox(
      width: size,
      height: size,
      child: Platform.isAndroid
          ? CircularProgressIndicator()
          : CupertinoActivityIndicator(),
    );

    return Center(
      child: spinner,
    );
  }
}
