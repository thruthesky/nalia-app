import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nalia_app/models/api.controller.dart';
import 'package:nalia_app/models/api.post.model.dart';
import 'package:nalia_app/screens/forum/widgets/post.edit.form.dart';
import 'package:nalia_app/screens/forum/widgets/post.view.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';
import 'package:nalia_app/widgets/spinner.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ForumListScreen extends StatefulWidget {
  @override
  _ForumListScreenState createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  Forum forum;
  @override
  void initState() {
    super.initState();
    forum = api.resetForum(
      category: Get.arguments['category'],
      render: () => setState(() => null),
    );
    fetchPosts();

    forum.itemPositionsListener.itemPositions.addListener(() {
      int lastVisibleIndex =
          forum.itemPositionsListener.itemPositions.value.last.index;
      if (forum.loading) return;
      if (lastVisibleIndex > forum.posts.length - 4) {
        fetchPosts();
      }
      // print('Item No: $lastVisibleIndex');
      // fetchPosts();
    });
  }

  /// TODO loading next page
  fetchPosts() async {
    // print('ForumListScreen::fetchPosts() pageNo: ${forum.pageNo}');
    try {
      await api.fetchPosts(forum: forum);
    } catch (e) {
      app.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.myJewelry),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(forum.category),
            TextButton(
              child: Text('Create'),
              onPressed: () => setState(() => forum.editPost(ApiPost())),
            )
          ],
        ),
        child: forum.postInEdit != null
            ? PostEditForm(forum)
            : Column(
                children: [
                  PostList(forum: forum),
                  Spinner(loading: forum.loading),
                  NoMorePosts(noMorePosts: forum.noMorePosts)
                ],
              ),
      ),
    );
  }
}

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
        child: ScrollablePositionedList.builder(
          itemScrollController: widget.forum.listController,
          itemPositionsListener: widget.forum.itemPositionsListener,
          itemCount: widget.forum.posts.length,
          itemBuilder: (_, i) {
            return PostView(forum: widget.forum, i: i);
          },
        ),
      ),
    );
  }
}

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
