import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/in_app_purchase.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';
import 'package:nalia_app/widgets/spinner.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  @override
  _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.purchase),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        child: Column(
          children: [
            spaceMd,
            Text('Jewelry box purchase history'),
            spaceMd,
            FutureBuilder(
              future: purchase.getMyPurchases,
              builder: (_, snapshot) {
                print(snapshot);
                if (snapshot.hasError) {
                  return Text('Oh! An error has occurred.');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Spinner();
                }

                List<dynamic> shot = snapshot.data;

                print(shot);

                // if (shot.size == 0) {
                //   return Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       spaceMd,
                //       Container(
                //         padding: EdgeInsets.all(md),
                //         child: Text('There is no jewelry box purchased.'),
                //         decoration: BoxDecoration(
                //           color: Colors.orange[100],
                //           borderRadius: BorderRadius.circular(50),
                //         ),
                //       ),
                //       spaceMd,
                //       TextButton(
                //         child: Text('Go to buy a jewelry box'),
                //         onPressed: () => app.open(RouteNames.purchase),
                //       )
                //     ],
                //   );
                // }

                return Text('Your history here');

                // return Expanded(
                //   child: ListView.builder(
                //     padding: pagePadding,
                //     itemCount: shot.docs.length,
                //     itemBuilder: (_, i) {
                //       final data = shot.docs[i].data();
                //       data['id'] = shot.docs[i].id;

                //       final session =
                //           PurchaseSession.fromSnapshot(shot.docs[i]);

                //       print(session);

                //       return Column(
                //         children: [
                //           Divider(),
                //           ListTile(
                //             leading: purchase.boxIcon(''),
                //             title: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 // Text(session.productDetails.id.tr),
                //                 // Text(priceFormat(session)),
                //                 // SizedBox(height: sm),
                //                 // Text('결과'),
                //                 // SizedBox(height: xs),
                //                 // Text(openResult(session)),
                //                 // SizedBox(height: sm),
                //               ],
                //             ),
                //             subtitle: Text('날짜: '
                //                 // + time(data['beginAt']),
                //                 ),
                //           )
                //         ],
                //       );
                //     },
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }

  time(int stamp) {
    if (stamp == null) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(stamp * 1000);
    return DateFormat('yyyy-MM-dd hh:mm aaa').format(dt);
  }

  boxIcon(PurchaseSession session) {
    return purchase.boxIcon(session.productDetails.id);
  }

  String priceFormat(PurchaseSession session) {
    return session.productDetails.price;
  }

  String openResult(PurchaseSession session) {
    if (session == null ||
        session.data == null ||
        session.data['credit'] == null)
      return '';
    else
      return '실버 ${session.data['credit']['silver']}개, 골드 ${session.data['credit']['gold']}개, 다이아몬드 ${session.data['credit']['diamond']}개';
  }
}
