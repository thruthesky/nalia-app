import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nalia_app/models/api.purchaseHistory.dart';
import 'package:nalia_app/services/svg_collections.dart';
import 'package:nalia_app/widgets/svg.dart';
import 'package:rxdart/rxdart.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:withcenter/withcenter.dart';

// const List<String> _kProductIds = <String>[
//   _kConsumableId,
//   'upgrade',
//   'subscription'
// ];

class SessionStatus {
  static final String pending = 'pending';
  static final String success = 'success';
  static final String failure = 'failure';
}

const String MISSING_PRODUCTS = 'MISSING_PRODUCTS';
const String PURCHASE_SESSION_NOT_FOUND = 'PURCHASE_SESSION_NOT_FOUND';

/// In app purchase
class FireflutterInAppPurchase {
  Map<String, ProductDetails> products = {};
  List<String> missingIds = [];

  Set<String> _productIds = {};

  /// [productReady] is being fired after it got product list from the server.
  ///
  /// The app can display product after this event.
  BehaviorSubject productReady = BehaviorSubject.seeded(null);

  /// It autoconsume the consumable product by default.
  /// If you set it to false, you must manually mark the product as consumed to enable another purchase (Android only).
  bool autoConsume;

  /// On `android` you need to specify which is consumable. By listing the product ids
  List consumableIds = [];

  /// [pending] event will be fired on incoming purchases or previous purchase of previous app session.
  ///
  /// The app can show a UI to display the payment is on going.
  ///
  /// Note that [pending] is `PublishSubject`. This means, the app must listen [pending] before invoking `init()`
  // ignore: close_sinks
  PublishSubject pending = PublishSubject<PurchaseDetails>();

  /// [error] event will be fired when any of purchase fails(or errors). This
  /// includes cancellation, verification failure, and other errors.
  ///
  /// Note that [error] is `PublishSubject`. This means, the app must listen [error] before invoking `init()`
  // ignore: close_sinks
  PublishSubject error = PublishSubject<PurchaseDetails>();

  /// [success] event will be fired after the purchase has made and the the app can
  /// deliver the purchase to user.
  ///
  /// Not that the app can then, connect to backend server to verifiy if the
  /// payment was really made and deliver products to user on the backend.
  ///
  /// Note that, the event data of [success] is `PurchaseDetails`
  ///
  // ignore: close_sinks
  PublishSubject<PurchaseDetails> success = PublishSubject<PurchaseDetails>();

  InAppPurchaseConnection connection = InAppPurchaseConnection.instance;

  /// Initialize payment
  ///
  /// Attention, [init] should be called after Firebase initialization since
  /// it may access database for pending purchase from previous app session.
  Future init({
    @required Set<String> productIds,
    List<String> consumableIds,
    bool autoConsume = true,
  }) {
    // print('Payment::init');
    this._productIds = productIds;
    this.consumableIds = consumableIds;
    this.autoConsume = autoConsume;
    _initIncomingPurchaseStream();
    return _initPayment();
  }

  /// Subscribe to any incoming(or pending) purchases
  ///
  /// It's important to listen as soon as possible to avoid losing events.
  _initIncomingPurchaseStream() {
    /// Listen to any pending & incoming purchases.
    ///
    /// If app crashed right after purchase but the purchase has not yet
    /// delivered, then, the purchase will be notified here with
    /// `PurchaseStatus.pending`. This is confirmed on iOS.
    ///
    /// Note, that this listener will be not unscribed since it should be
    /// lifetime listener
    ///
    /// Note, for the previous app session pending purchase, listener event will be called
    /// one time only on app start after closing. Hot-Reload or Full-Reload is not working.
    connection.purchaseUpdatedStream.listen((dynamic purchaseDetailsList) {
      print('purchaseUpdatedStream.listen( ${purchaseDetailsList.length} )');
      purchaseDetailsList.forEach(
        (PurchaseDetails purchaseDetails) async {
          print('purchaseDetailsList.forEach( ... )');
          // All purchase event(pending, success, or cancelling) comes here.

          // if it's pending, this mean, the user just started to pay.
          // previous app session pending purchase is not `PurchaseStatus.pending`. It is either
          // `PurchaseStatus.purchased` or `PurchaseStatus.error`
          if (purchaseDetails.status == PurchaseStatus.pending) {
            print('=> pending on purchaseUpdatedStream');
            print(purchaseDetails.toString());
            pending.add(purchaseDetails);
            _recordPending(purchaseDetails);
          } else if (purchaseDetails.status == PurchaseStatus.error) {
            print('=> error on purchaseUpdatedStream');
            print(purchaseDetails.toString());
            error.add(purchaseDetails);
            _recordFailure(purchaseDetails);
            if (Platform.isIOS) {
              connection.completePurchase(purchaseDetails);
            }
          } else if (purchaseDetails.status == PurchaseStatus.purchased) {
            print('=> purchased on purchaseUpdatedStream');
            print(purchaseDetails.toString());
            // for android & consumable product only.
            if (Platform.isAndroid) {
              if (!autoConsume && consumableIds.contains(purchaseDetails.productID)) {
                await connection.consumePurchase(purchaseDetails);
              }
            }
            if (purchaseDetails.pendingCompletePurchase) {
              await connection.completePurchase(purchaseDetails);
              await _recordSuccess(purchaseDetails);
              success.add(purchaseDetails);
            }
          }
        },
      );
    }, onDone: () {
      print('onDone:');
    }, onError: (error) {
      print('onError: error on listening:');
      print(error);
    });
  }

  /// Init the in-app-purchase
  ///
  /// - Get products based on the [productIds]
  _initPayment() async {
    final bool available = await connection.isAvailable();

    if (available) {
      ProductDetailsResponse response = await connection.queryProductDetails(_productIds);

      /// Check if any of given product id(s) are missing.
      if (response.notFoundIDs.isNotEmpty) {
        missingIds = response.notFoundIDs;
      }

      response.productDetails.forEach((product) => products[product.id] = product);

      productReady.add(products);
    } else {
      print('===> InAppPurchase connection is NOT avaible!');
    }
  }

  _recordPending(PurchaseDetails purchaseDetails) async {
    ProductDetails productDetails = products[purchaseDetails.productID];
    if (Platform.isIOS && purchaseDetails?.verificationData == null) {
      // todo On iOS, this may be null. Call [InAppPurchaseConnection.refreshPurchaseVerificationData] to get a new [PurchaseVerificationData] object for further validation.
    }
    final Map<String, dynamic> data = {
      'status': SessionStatus.pending,
      'productDetails_id': productDetails?.id,
      'productDetails_title': productDetails?.title,
      'productDetails_description': productDetails?.description,
      'productDetails_price': productDetails?.price,
      'purchaseDetails_productID': purchaseDetails?.productID,
      'purchaseDetails_pendingCompletePurchase': purchaseDetails?.pendingCompletePurchase,
      'purchaseDetails_verificationData_localVerificationData':
          purchaseDetails?.verificationData?.localVerificationData,
      'purchaseDetails_verificationData_serverVerificationData':
          purchaseDetails?.verificationData?.serverVerificationData,
    };
    print('psending data:');
    print(jsonEncode(data));

    await withcenterApi.recordFailurePurchase(data);
  }

  _recordFailure(PurchaseDetails purchaseDetails) async {
    print(purchaseDetails);
    final Map<String, dynamic> data = {
      'status': SessionStatus.failure,
      'purchaseDetails_productID': purchaseDetails?.productID,
      'purchaseDetails_skPaymentTransaction_transactionIdentifier':
          purchaseDetails?.skPaymentTransaction?.transactionIdentifier,
    };
    await withcenterApi.recordFailurePurchase(data);
  }

  _recordSuccess(PurchaseDetails purchaseDetails) async {
    ProductDetails productDetails = products[purchaseDetails.productID];
    final Map<String, dynamic> data = {
      'status': SessionStatus.success,
      'productDetails_id': productDetails?.id,
      'productDetails_price': productDetails?.price,
      'productDetails_title': productDetails?.title,
      'productDetails_description': productDetails?.description,
      'purchaseDetails_transactionDate': purchaseDetails?.transactionDate,
      'purchaseDetails_purchaseID': purchaseDetails?.purchaseID,
      'purchaseDetails_skPaymentTransaction_payment_productIdentifier':
          purchaseDetails?.skPaymentTransaction?.payment?.productIdentifier,
      'purchaseDetails_skPaymentTransaction_payment_quantity':
          purchaseDetails?.skPaymentTransaction?.payment?.quantity,
      'purchaseDetails_skPaymentTransaction_transactionIdentifier':
          purchaseDetails?.skPaymentTransaction?.transactionIdentifier,
      'purchaseDetails_skPaymentTransaction_transactionTimeStamp':
          purchaseDetails?.skPaymentTransaction?.transactionTimeStamp,
      'purchaseDetails_verificationData_localVerificationData':
          purchaseDetails?.verificationData?.localVerificationData.toString(),
      'purchaseDetails_verificationData_serverVerificationData':
          purchaseDetails?.verificationData?.serverVerificationData,
      'purchaseDetails_pendingCompletePurchase': purchaseDetails?.pendingCompletePurchase,
      'productDetails_skProduct_price': productDetails?.skProduct?.price != null
          ? productDetails?.skProduct?.price
          : productDetails?.skuDetail?.price,
      'productDetails_skProduct_priceLocale_currencyCode':
          productDetails?.skProduct?.priceLocale?.currencyCode != null
              ? productDetails?.skProduct?.priceLocale?.currencyCode
              : productDetails?.skuDetail?.priceCurrencyCode,
      'productDetails_skProduct_priceLocale_currencySymbol':
          productDetails?.skProduct?.priceLocale?.currencySymbol,
      'productDetails_skProduct_productIdentifier': productDetails?.skProduct?.productIdentifier,
    };

    print('success data:');
    print(purchaseDetails?.verificationData?.localVerificationData.toString());
    print(purchaseDetails?.verificationData?.serverVerificationData.toString());
    print(jsonEncode(data));
    print('-----');
    print(jsonEncode(purchaseDetails.toString()));

    if (purchaseDetails.verificationData.source == IAPSource.AppStore) {}

    await withcenterApi.recordSuccessPurchase(data);
  }

  Future buyConsumable(ProductDetails product) async {
    PurchaseParam purchaseParam = PurchaseParam(
      productDetails: product,
    );

    await connection.buyConsumable(
      purchaseParam: purchaseParam,
    );
  }

  /// Returns the Collection Query to get the login user's success purchases.
  Future<List<PurchaseHistory>> get getMyPurchases async {
    final List<dynamic> res = await withcenterApi.getMyPurchases();
    List<PurchaseHistory> purchaseHistory = [];
    for (int i = 0; i < res.length; i++) {
      purchaseHistory.add(PurchaseHistory.fromJson(res[i]));
    }
    return purchaseHistory;
  }

  boxIcon(String id) {
    if (id == 'lucky_box') return Svg(heartBoxSvg, width: 38);
    if (id == 'jewelry_box') return Svg(goldSvg, width: 38);
    if (id == 'diamond_box') return Svg(diamondSvg, width: 40);
  }
}
