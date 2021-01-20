import 'package:flutter/material.dart';
import 'package:nalia_app/services/defines.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/route_names.dart';
import 'package:nalia_app/widgets/custom_app_bar.dart';
import 'package:nalia_app/widgets/home.content_wrapper.dart';

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
          padding: EdgeInsets.all(xs),
          child: Column(
            children: [
              iapService.buildProductList(),
            ],
          ),
        ),
      ),
    );
  }
}
