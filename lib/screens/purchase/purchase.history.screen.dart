// import 'package:dating/services/definitions.dart';
// import 'package:dating/services/globals.dart';
// import 'package:dating/widgets/spinner.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fireflutter_in_app_purchase/fireflutter_in_app_purchase.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class PurchaseHistoryScreen extends StatefulWidget {
//   @override
//   _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
// }

// class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
//   @override
//   void initState() {
//     super.initState();

//     init();
//   }

//   init() async {}

//   time(Timestamp stamp) {
//     if (stamp == null) return '';
//     final dt = DateTime.fromMillisecondsSinceEpoch(stamp.seconds * 1000);
//     return DateFormat('yyyy-MM-dd hh:mm aaa').format(dt);
//   }

//   boxIcon(PurchaseSession session) {
//     return app.boxIcon(session.productDetails.id);
//   }

//   String priceFormat(PurchaseSession session) {
//     return session.productDetails.price;
//     // String str = session.productDetails.price;
//     // str = str.replaceFirst('₩', '');
//     // int n = int.parse(str);
//     // return NumberFormat.currency(
//     //   locale: 'ko_KR',
//     //   symbol: '₩',
//     // ).format(n);
//   }

//   String openResult(PurchaseSession session) {
//     if (session == null ||
//         session.data == null ||
//         session.data['credit'] == null)
//       return '';
//     else
//       return '실버 ${session.data['credit']['silver']}개, 골드 ${session.data['credit']['gold']}개, 다이아몬드 ${session.data['credit']['diamond']}개';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           spaceMd,
//           Text('보석상자 구매 내역'),
//           spaceMd,
//           FutureBuilder(
//             future: purchase.getMyPurchases,
//             builder: (_, snapshot) {
//               if (snapshot.hasError) {
//                 return Text('앗! 에러가 발생하였습니다.');
//               }
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Spinner();
//               }

//               QuerySnapshot shot = snapshot.data;
//               if (shot.size == 0) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     spaceMd,
//                     Container(
//                       padding: EdgeInsets.all(md),
//                       child: Text('구매한 보석 상자가 없습니다.'),
//                       decoration: BoxDecoration(
//                         color: Colors.orange[100],
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                     ),
//                     spaceMd,
//                     TextButton(
//                       child: Text('보석 상자 구매하러 가기'),
//                       onPressed: () => app.open(RouteName.purchase),
//                     )
//                   ],
//                 );
//               }

//               return Expanded(
//                 child: ListView.builder(
//                   padding: pagePadding,
//                   itemCount: shot.docs.length,
//                   itemBuilder: (_, i) {
//                     final data = shot.docs[i].data();
//                     data['id'] = shot.docs[i].id;

//                     final session = PurchaseSession.fromSnapshot(shot.docs[i]);

//                     return Column(
//                       children: [
//                         Divider(),
//                         ListTile(
//                           leading: boxIcon(session),
//                           title: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(session.productDetails.id.tr),
//                               Text(priceFormat(session)),
//                               SizedBox(height: sm),
//                               Text('결과'),
//                               SizedBox(height: xs),
//                               Text(openResult(session)),
//                               SizedBox(height: sm),
//                             ],
//                           ),
//                           subtitle: Text(
//                             '날짜: ' + time(data['beginAt']),
//                           ),
//                         )
//                       ],
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
