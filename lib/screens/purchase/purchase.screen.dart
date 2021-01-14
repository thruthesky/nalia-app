import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';
import 'package:nalia_app/widgets/spinner.dart';

class PurchaseScreen extends StatefulWidget {
  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(route: RouteNames.purchase),
      backgroundColor: kBackgroundColor,
      body: HomeContentWrapper(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                  stream: purchase.productReady,
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      print('payment.products => snapshot.hasError');
                      return SizedBox.shrink();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Spinner();
                    }
                    if (purchase.products.isEmpty) {
                      return Container(
                        padding: EdgeInsets.all(32),
                        child: Text("Oh, there is no product to pay."),
                      );
                    }

                    return Column(
                      children: [
                        spaceMd,
                        Text('Jewelry box purchase'),
                        spaceMd,
                        Text('If you buy gems, you can get gems at random.'),
                        spaceMd,
                        Container(
                          padding: pagePadding,
                          decoration: BoxDecoration(
                              color: Colors.amber[50],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5.0, color: Colors.grey[300], spreadRadius: 5.0),
                              ]),
                          child: Column(
                            children: [
                              ProductDetail(purchase.products['lucky_box']),
                              Divider(),
                              ProductDetail(purchase.products['jewelry_box']),
                              Divider(),
                              ProductDetail(purchase.products['diamond_box']),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetail extends StatelessWidget {
  ProductDetail(this.product, {Key key}) : super(key: key);
  final ProductDetails product;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: purchase.boxIcon(product.id),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.title ?? product.id),
            spaceXs,
            Text(product.price),
            spaceXs,
            Text(
              product.description ?? product.id,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            spaceSm,
            Text(
              'Purchase',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        onTap: () async {
          print('purchase product');
          try {
            await api.checkUserProfile();
            await purchase.buyConsumable(product);
            // todo: after pay, moving a new screen and in the new screen, generate random jewelry immediately without user's consent.
          } catch (e) {
            print('purchase.instance.buyConsumable e: ');
            print(e);
            app.error(e);
          }
        },
      ),
    );
  }
}
