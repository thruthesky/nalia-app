import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  const Spinner({Key key, this.size = 24, this.loading = true})
      : super(key: key);

  final double size;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading == false) return SizedBox.shrink();
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
