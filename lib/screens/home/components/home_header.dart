import 'dart:async';
import 'dart:convert';
import 'package:IrisBag/constants.dart';
import 'package:IrisBag/screens/cart_unit_test/cart/cart_screen.dart';
import 'package:IrisBag/screens/sign_in/sign_in_screen.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:IrisBag/models/CartModel.dart' as CartData;
import '../../../constant/api_services.dart';
import '../../../models/widgetjson.dart';
import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeHeader extends StatefulWidget {
  final int itemCount;
  final String color;
  const HomeHeader({Key? key, required this.itemCount, required this.color})
      : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState(itemCount, this.color);
}

class _HomeHeaderState extends State<HomeHeader> {
  late SharedPreferences preferences;
  late String token;

  // widgetjson getjson = new widgetjson(banner: []);
  CartData.CartModel cartModel = CartData.CartModel(
      // message: "",
      data: CartData.Data(
          id: 0,
          customerEmail: "",
          customerFirstName: "",
          customerLastName: "",
          isGift: 0,
          itemsCount: 0,
          itemsQty: "",
          globalCurrencyCode: "",
          baseCurrencyCode: "",
          channelCurrencyCode: "",
          cartCurrencyCode: "",
          grandTotal: "0",
          formatedGrandTotal: "",
          baseGrandTotal: "",
          formatedBaseGrandTotal: "",
          subTotal: "",
          formatedSubTotal: "",
          baseSubTotal: "",
          formatedBaseSubTotal: "",
          taxTotal: "",
          formatedTaxTotal: "",
          baseTaxTotal: "",
          formatedBaseTaxTotal: "",
          discount: "",
          formatedDiscount: "",
          baseDiscount: "",
          formatedBaseDiscount: "",
          isGuest: 0,
          isActive: 0,
          items: [],
          createdAt: "",
          updatedAt: "",
          taxes: "",
          formatedTaxes: "",
          baseTaxes: "",
          formatedBaseTaxes: "",
          formatedDiscountedSubTotal: "",
          formatedBaseDiscountedSubTotal: ""));

  _HomeHeaderState(this.itemCount, this.color);
  int itemCount;
  String color;

  StreamController<CartData.CartModel> _streamController = StreamController();
  getCartData() async {
    preferences = await SharedPreferences.getInstance();
    this.token = preferences.getString("loggedIntoken").toString();
    dynamic data = await APIService.GetCartItem(token);

    cartModel = CartData.CartModel.fromJson(data);

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          cartModel = CartData.CartModel.fromJson(data);
        }));
  }

  @override
  void onDetached() {
    getCartData();
  }

  @override
  void onInactive() {
    getCartData();
  }

  @override
  void onPaused() {
    getCartData();
  }

  @override
  void onResumed() {
    getCartData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(Duration(seconds: 3), (timer) {
      getCartData();
    });
    readJson();
  }

  widgetjson getjson = new widgetjson(banner: []);
  readJson() async {
    final data = await APIService.jsonfile();

    setState(() {
      getjson = widgetjson.fromJson(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconBtnWithCounter(
              svgSrc: "assets/icons/Search Icon.svg",
              color: getjson.banner.isNotEmpty
                  ? getjson.banner[0].primaryColor
                  : kPrimaryColor,
              press: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage())),
            ),
            SizedBox(
              width: 20,
            ),
            IconBtnWithCounter(
              svgSrc: Theme_Settings.HomeHeaderCartIcon,
              color: getjson.banner.isNotEmpty
                  ? getjson.banner[0].primaryColor
                  : kPrimaryColor,
              numOfitem: cartModel.data.itemsQty.isNotEmpty
                  ? int.parse(cartModel.data.itemsQty
                      .toString()
                      .substring(0, cartModel.data.itemsQty.indexOf(".")))
                  : 0,
              press: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartUnitTesting()));
              },
            ),
          ],
        ));
  }
}
