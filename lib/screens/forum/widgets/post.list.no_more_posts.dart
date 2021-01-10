import 'package:flutter/material.dart';

class NoMorePosts extends StatelessWidget {
  const NoMorePosts({Key key, @required this.noMorePosts}) : super(key: key);

  final bool noMorePosts;

  @override
  Widget build(BuildContext context) {
    return noMorePosts
        ? SafeArea(
            child: Text('No more posts'),
          )
        : SizedBox.shrink();
  }
}
