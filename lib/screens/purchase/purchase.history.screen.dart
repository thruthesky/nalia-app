import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.purchaseHistory.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
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

                List<PurchaseHistory> shot = snapshot.data;

                if (shot.length == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      spaceMd,
                      Container(
                        padding: EdgeInsets.all(md),
                        child: Text('There is no jewelry box purchased.'),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      spaceMd,
                      TextButton(
                        child: Text('Go to buy a jewelry box'),
                        onPressed: () => app.open(RouteNames.purchase),
                      )
                    ],
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    padding: pagePadding,
                    itemCount: shot.length,
                    itemBuilder: (_, i) {
                      final data = shot[i];

                      print(data);

                      return Column(
                        children: [
                          Divider(),
                          ListTile(
                            leading: purchase.boxIcon(data.productDetailsId),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data.productDetailsId),
                                if (data.productDetailsTitle != '') Text(data.productDetailsTitle),
                                if (data.productDetailsDescription != '')
                                  Text(data.productDetailsDescription),
                                Text(data.productDetailsPrice),
                                SizedBox(height: sm),
                                Text('result'),
                                // SizedBox(height: xs),
                                // Text(openResult(session)),
                                // SizedBox(height: sm),
                              ],
                            ),
                            subtitle: Text(
                              'Date: ' + time(data.stamp),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  time(String stamp) {
    if (stamp == null) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(int.parse(stamp) * 1000);
    return DateFormat('yyyy-MM-dd hh:mm aaa').format(dt);
  }

  String priceFormat(PurchaseHistory rec) {
    return rec.purchaseDetailsPrice;
  }

  String openResult(PurchaseHistory rec) {
    if (rec == null)
      return '';
    else
      // return '실버 ${session.data['credit']['silver']}개, 골드 ${session.data['credit']['gold']}개, 다이아몬드 ${session.data['credit']['diamond']}개';
      // return 'Silver ${rec.data['credit']['silver']}, gold ${session.data['credit']['gold']} diamonds, ${session.data['credit']['diamond']}';
      return 'result';
  }
}
