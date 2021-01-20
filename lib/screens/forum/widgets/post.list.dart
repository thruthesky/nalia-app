import 'package:flutter/material.dart';
import 'package:nalia_app/controllers/api.controller.dart';
import 'package:nalia_app/screens/forum/widgets/post.view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class PostList extends StatefulWidget {
  PostList({@required this.forum});
  final Forum forum;
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {
    if (widget.forum.canList == false) return SizedBox.shrink();
    return Expanded(
      child: Container(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ScrollablePositionedList.builder(
            itemScrollController: widget.forum.listController,
            itemPositionsListener: widget.forum.itemPositionsListener,
            itemCount: widget.forum.posts.length,
            itemBuilder: (_, i) {
              return PostView(forum: widget.forum, i: i);
            },
          ),
        ),
      ),
    );
  }
}
