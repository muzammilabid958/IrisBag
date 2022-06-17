import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:IrisBag/models/widgetjson.dart';
import 'package:IrisBag/screens/sign_in/sign_in_screen.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:async_loader/async_loader.dart';
import 'package:IrisBag/models/AddToCart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/components/product_card.dart';
import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/constant/config.dart';
import 'package:IrisBag/constants.dart';
import 'package:IrisBag/models/FeatureProduct.dart';
import 'package:IrisBag/models/LoggedInUser.dart';
import 'package:IrisBag/models/Product.dart';
import 'package:IrisBag/models/WishListProduct.dart';
import 'package:IrisBag/screens/details/details_screen.dart';
import 'package:IrisBag/screens/feature_view/components/featureproduct.dart';
import 'package:awesome_loader/awesome_loader.dart';
import '../../../size_config.dart';
import 'section_title.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:badges/badges.dart';

class NewProducts extends StatefulWidget {
  String name;
  NewProducts({Key? key, required this.name}) : super(key: key);

  @override
  _NewProductsState createState() => _NewProductsState(this.name);
}

class _NewProductsState extends State<NewProducts> {
  late FeatureProduct product = new FeatureProduct(data: []);
  int length = 0;
  bool loader = false;
  String name;
  _NewProductsState(this.name);
  @override
  void initState() {
    super.initState();

    getFeaturedProduct();
    readJson();
  }

  late widgetjson getjson;
  readJson() async {
    final jsondata = await APIService.jsonfile();

    getjson = widgetjson.fromJson(jsondata);
    setState(() {
      getjson = widgetjson.fromJson(jsondata);
    });
  }

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  getFeaturedProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("loggedIntoken").toString();
    dynamic data = await APIService.FeatureProductListing(token, "?new=1");

    setState(() {
      product = FeatureProduct?.fromJson(data);
    });
  }

  static const TIMEOUT = const Duration(seconds: 5);

  getMessage() async {
    return new Future.delayed(TIMEOUT, () => {});
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    var _asyncLoader = AsyncLoader(
        key: _asyncLoaderState,
        initState: () async => await getMessage(),
        renderLoad: () => new Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: AwesomeLoader(
                        loaderType: AwesomeLoader.AwesomeLoader3,
                        color: HexColor(Theme_Settings.loaderColor['color']),
                      ))
                ])),
        renderError: ([error]) => new Text('Something Went Wrong'),
        renderSuccess: ({data}) => Container(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    product.data.length,
                    (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: getProportionateScreenWidth(20)),
                        child: SizedBox(
                          width: getProportionateScreenWidth(140),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          id: product.data[index].id.toString(),
                                        )),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                product.data[index].formatedSpecialPrice
                                            .toString()
                                            .isNotEmpty &&
                                        product.data[index].DiscountPercentage
                                                .toString() !=
                                            "null"
                                    ? Badge(
                                        badgeContent: Text(
                                          product.data[index].DiscountPercentage
                                                  .toString()
                                                  .substring(
                                                      0,
                                                      product.data[index]
                                                          .DiscountPercentage
                                                          .indexOf('.')) +
                                              " %",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        shape: BadgeShape.square,
                                        child: AspectRatio(
                                          aspectRatio: 0.8,
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            padding: EdgeInsets.all(
                                                getProportionateScreenWidth(
                                                    20)),

                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 3,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),

                                            child: CachedNetworkImage(
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              imageUrl: product
                                                  .data[index].images[0].url
                                                  .toString(),
                                              placeholder: (context, url) =>
                                                  new Center(
                                                      child: CircularProgressIndicator(
                                                          color: Colors
                                                                  .amberAccent[
                                                              400])),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                'assets/images/Placeholders.png',
                                              ),
                                            ),
                                            // ),
                                          ),
                                        ))
                                    : AspectRatio(
                                        aspectRatio: 0.8,
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          padding: EdgeInsets.all(
                                              getProportionateScreenWidth(20)),

                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 3,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),

                                          child: CachedNetworkImage(
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            imageUrl: product
                                                .data[index].images[0].url
                                                .toString(),
                                            placeholder: (context, url) =>
                                                new Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color: Colors
                                                                    .amberAccent[
                                                                400])),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              'assets/images/Placeholders.png',
                                            ),
                                          ),
                                          // ),
                                        ),
                                      ),
                                const SizedBox(height: 10),
                                Text(
                                  product.data[index].name.toString(),
                                  // style: TextStyle(color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    product.data[index].formatedSpecialPrice
                                                .toString()
                                                .isNotEmpty &&
                                            product.data[index]
                                                    .formatedSpecialPrice
                                                    .toString() !=
                                                "null"
                                        ? Column(children: [
                                            Text(
                                                product
                                                    .data[index].formatedPrice
                                                    .toString(),
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough)),
                                            Text(
                                              product.data[index]
                                                  .formatedSpecialPrice
                                                  .toString(),
                                              style: TextStyle(
                                                color: HexColor(getjson
                                                    .banner[0].primaryColor),
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        14),
                                                fontWeight: FontWeight.w600,
                                                // color: HexColor(getjson.banner[0].primaryColor),
                                              ),
                                            ),
                                          ])
                                        : Text(
                                            product.data[index].formatedPrice
                                                .toString(),
                                            style: TextStyle(
                                              color: HexColor(getjson
                                                  .banner[0].primaryColor),
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      14),
                                              fontWeight: FontWeight.w600,
                                              // color: HexColor(getjson.banner[0].primaryColor),
                                            ),
                                          ),
                                    product.data[index].productQty > 0
                                        ? InkWell(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            onTap: () async {
                                              SharedPreferences preferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String userID = preferences
                                                  .getString("UserID")
                                                  .toString();

                                              if (userID == "null") {
                                                // Navigator.pushNamed(context,
                                                //     SignInScreen.routeName);
                                                AddToCartModel cartModel =
                                                    AddToCartModel(
                                                        productId: product
                                                            .data[index].id
                                                            .toString(),
                                                        quantity: "1");
                                                dynamic data =
                                                    await APIService.AddToCart(
                                                        cartModel, "");

                                                Fluttertoast.showToast(
                                                    msg: data['message']
                                                        .toString());
                                              } else {
                                                AddToCartModel cartModel =
                                                    AddToCartModel(
                                                        productId: product
                                                            .data[index].id
                                                            .toString(),
                                                        quantity: "1");
                                                dynamic data =
                                                    await APIService.AddToCart(
                                                        cartModel,
                                                        preferences
                                                            .getString(
                                                                'loggedIntoken')
                                                            .toString());
                                                print(data);

                                                // CartModel cartResponseModel =
                                                //     CartModel.fromJson(json.decode(data));

                                                Fluttertoast.showToast(
                                                    msg: data['message']
                                                        .toString());
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(5),
                                              padding: EdgeInsets.all(
                                                  getProportionateScreenWidth(
                                                      8)),
                                              height:
                                                  getProportionateScreenWidth(
                                                      28),
                                              width:
                                                  getProportionateScreenWidth(
                                                      28),
                                              decoration: BoxDecoration(
                                                color: true
                                                    ? HexColor(getjson.banner[0]
                                                            .primaryColor)
                                                        .withOpacity(0.15)
                                                    // ignore: dead_code
                                                    : kSecondaryColor
                                                        .withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: SvgPicture.asset(
                                                "assets/icons/Cart Icon.svg",
                                                // color: product.data[index].isWishlisted
                                                //     ? Color(0xFFFF4848)
                                                //     : Color(0xFFDBDEE4),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            "Out of Stock",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      9),
                                            ),
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                ],
              ),
            )));
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: name.toString() + " Products",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FeatureViewAllProduct(
                              flag: name.toString().toLowerCase(),
                            )));
              }),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        _asyncLoader
      ],
    );
  }
}
