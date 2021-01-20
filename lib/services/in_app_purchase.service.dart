import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nalia_app/services/global.dart';
import 'package:nalia_app/services/svg_collections.dart';
import 'package:nalia_app/widgets/svg.dart';

class InAppPurchaseService {
  // Set literals require Dart 2.2. Alternatively, use `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
  final Set<String> _kIds = {
    'goldbox',
    'diamondbox',
  };
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;

  /// Subscription for purchase updated streem. This should be the app's life
  /// time period subscription that means it should not be cancelled until the
  /// app closed.
  StreamSubscription<List<PurchaseDetails>> _subscription;

  // List<ProductDetails> products;
  Map<String, ProductDetails> products = {};

// Subscribe to any incoming purchases at app initialization. These can
// propagate from either storefront so it's important to listen as soon as
// possible to avoid losing events.
  Future init() async {
    // Is store available?
    final bool available = await _connection.isAvailable();
    if (!available) {
      alert('Connection Error', 'The store cannot be reached or accessed');
    }

    // Get product items
    final ProductDetailsResponse response = await _connection.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      print('Some of purchase items from $_kIds are NOT exist!');
    }
    // products = response.productDetails;
    response.productDetails.forEach((product) => products[product.id] = product);
    if (products.isEmpty) {
      alert('No Purchase Item', 'No purchase item is available.');
    }

    // Subscribe for incoming purchases.
    _subscription = _connection.purchaseUpdatedStream.listen(
      _listenToPurchaseUpdated,
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        alert("Purchase Update Error", error.toString());
      },
    );

    // var paymentWrapper = SKPaymentQueueWrapper();
    // var transactions = await paymentWrapper.transactions();
    // print("transactions:");
    // print(transactions);
    // transactions.forEach((transaction) async {
    //   print("transacton:");
    //   print(transaction);
    //   await paymentWrapper.finishTransaction(transaction);
    // });
  }

  alert(String title, String message) {
    print("InAppPurchaseService::alert($title, $message)");
    Get.snackbar(
      title,
      message,
      animationDuration: Duration(milliseconds: 700),
    );
  }

  /// Incoming purchase handler
  _listenToPurchaseUpdated(purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("==> if (purchaseDetails.status == PurchaseStatus.pending)");
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        print("==> if (purchaseDetails.status == PurchaseStatus.error)");
        // 공식문서: iOS 에서 PurchaseStatus.error 인 경우, completePurchase() 를 해야 함.
        if (Platform.isIOS) {
          _connection.completePurchase(purchaseDetails);
        }
        // await _connection.consumePurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        print("==> if (purchaseDetails.status == PurchaseStatus.purchased)");

        _verifyPurchase(purchaseDetails);

        if (purchaseDetails.pendingCompletePurchase) {
          BillingResultWrapper brw =
              await InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
          if (brw.responseCode == BillingResponse.error ||
              brw.responseCode == BillingResponse.serviceUnavailable) {
            // TODO: retry to get BillingResultWrapper
          }
        }
      }
    });
  }

  boxIcon(String id) {
    if (id == 'goldbox') return Svg(goldSvg, width: 38);
    if (id == 'diamondbox' || id == 'goldbox') return Svg(diamondSvg, width: 40);
  }

  buildProductList() {
    final ListTile productHeader = ListTile(title: Text('Products for Sale'));
    List<ListTile> productList = <ListTile>[];

    productList.addAll(products.entries.map((entry) {
      ProductDetails productDetails = entry.value;
      return ListTile(
          leading: boxIcon(productDetails.id),
          title: Text(
            productDetails.title,
          ),
          subtitle: Text(
            productDetails.description,
          ),
          trailing: TextButton(
            child: Text(productDetails.price),
            style: TextButton.styleFrom(
              backgroundColor: Colors.green[800],
              primary: Colors.white,
            ),
            onPressed: () {
              _connection.buyConsumable(
                purchaseParam: PurchaseParam(productDetails: productDetails, sandboxTesting: false),
              );
            },
          ));
    }));

    return Card(child: Column(children: <Widget>[productHeader, Divider()] + productList));
  }

  _verifyPurchase(PurchaseDetails purchaseDetails) {
    ProductDetails productDetails = products[purchaseDetails.productID];
    final Map<String, dynamic> data = {
      'user_ID': api.id,
      'productID': purchaseDetails.productID,
      'purchaseID': purchaseDetails.purchaseID,
      'price': productDetails.price,
      'title': productDetails.title,
      'description': productDetails.description,
      'transactionDate': purchaseDetails.transactionDate,
      'localVerificationData': purchaseDetails.verificationData.localVerificationData,
      'serverVerificationData': purchaseDetails.verificationData.serverVerificationData,
    };

    if (purchaseDetails.verificationData.source == IAPSource.AppStore) {
      data['platform'] = 'ios';
    } else if (purchaseDetails.verificationData.source == IAPSource.GooglePlay) {
      data['platform'] = 'android';
    }

    // Android has no skPaymentTransaction
    if (purchaseDetails.skPaymentTransaction != null) {
      data['applicationUsername'] =
          purchaseDetails.skPaymentTransaction?.payment?.applicationUsername;
      data['productIdentifier'] = purchaseDetails.skPaymentTransaction?.payment?.productIdentifier;
      data['quantity'] = purchaseDetails.skPaymentTransaction?.payment?.quantity;
      data['transactionIdentifier'] = purchaseDetails.skPaymentTransaction?.transactionIdentifier;
      data['transactionTimeStamp'] = purchaseDetails.skPaymentTransaction?.transactionTimeStamp;
    }

    print('data: ');
    print(data);
    print(jsonEncode(data));
    requestVerification(data);
  }

  Future requestVerification(Map<String, dynamic> data) async {
    data['route'] = 'nalia.verifyPurchase';
    try {
      final re = await api.request(data);
      print(re);
    } catch (e) {
      print('e: $e');
    }
  }
}
