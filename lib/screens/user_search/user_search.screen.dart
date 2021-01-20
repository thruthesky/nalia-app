import 'package:flutter/material.dart';
import 'package:nalia_app/controllers/api.bio.controller.dart';
import 'package:nalia_app/models/api.bio.model.dart';
import 'package:nalia_app/models/api.bio.search.model.dart';
import 'package:nalia_app/controllers/api.user_card.controller.dart';
import 'package:nalia_app/screens/user_search/user_search.options.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';
import 'package:nalia_app/widgets/user_avatar.dart';

class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final options = ApiBioSearch();
  List<ApiBio> users;

  fetchUsers() async {
    try {
      users = await Bio.to.search();
      print(users.length);
      setState(() {});
    } catch (e) {
      app.error(e);
    }
  }

  onSearchOptionChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.jewelry),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        child: Column(
          children: [
            Text('User search'),
            UserSearchOptions(options: options, onSearchOptionChanged: onSearchOptionChanged),
            Expanded(
              child: UserList(users: users),
            ),
          ],
        ),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  UserList({
    Key key,
    this.users,
  }) : super(key: key);

  final List<ApiBio> users;

  @override
  Widget build(BuildContext context) {
    if (users == null) return SizedBox.shrink();
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (_, i) {
        ApiBio user = users[i];
        return ListTile(
          leading: UserAvatar(user.profilePhotoUrl),
          title: Text(user.name),
          subtitle: Text('${user.age}세'),
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            print('on tap:');
            UserCardController.to.insertUser(user);
            // app.homeStackChange(HomeStack.userCard);
            app.open(RouteNames.home);
          },
        );
      },
    );
  }
}
