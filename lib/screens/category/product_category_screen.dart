import 'dart:convert';

import 'package:IrisBag/screens/filter/filter.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/constant/config.dart';
import 'package:IrisBag/models/AddToCart.dart';
import 'package:IrisBag/models/CartModel.dart';
import 'package:IrisBag/models/CategoryProduct.dart';
import 'package:IrisBag/models/FeatureProduct.dart';
import 'package:IrisBag/models/WishListProduct.dart';
import 'package:IrisBag/screens/details/details_screen.dart';
import 'package:awesome_loader/awesome_loader.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:badges/badges.dart';
import '../../models/widgetjson.dart';
import '../sign_in/sign_in_screen.dart';

class CategoryAllProduct extends StatefulWidget {
  static String routeName = "/CategoryAllProduct";
  String id;
  CategoryAllProduct({Key? key, required this.id}) : super(key: key);

  @override
  _CategoryAllProductState createState() => _CategoryAllProductState(this.id);
}

class _CategoryAllProductState extends State<CategoryAllProduct> {
  late CategoryProduct product = new CategoryProduct(data: []);
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  String id;
  _CategoryAllProductState(this.id);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(id);
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = AsyncLoader(
        key: _asyncLoaderState,
        initState: () async => await getMessage(),
        renderLoad: () => Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  AwesomeLoader(
                    loaderType: AwesomeLoader.AwesomeLoader3,
                    color: HexColor(Theme_Settings.loaderColor['color']),
                  )
                ])),
        renderError: ([error]) => Text('Something Went Wrong'),
        renderSuccess: ({data}) => product.data.isNotEmpty
            ? CustomScrollView(slivers: <Widget>[
                _buildPopularRestaurant(),
              ])
            : const Center(
                child: Text("No Product Found"),
              ));

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FilterPage(cate: this.id)),
                  );
                },
                icon: Icon(Icons.filter_alt_outlined))
          ],
          title: const Text(
            "Product",
          ),
        ),
        body: _asyncLoader);
  }

  getData(String id) async {
    product.data.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("loggedIntoken").toString();
    dynamic data = await APIService.CategoryWiseProduct(token, id);

    setState(() {
      product = CategoryProduct.fromJson(data);
    });
  }

  late widgetjson getjson;
  readJson() async {
    final data = await APIService.jsonfile();
    getjson = widgetjson.fromJson(data);
    setState(() {
      getjson = widgetjson.fromJson(data);
    });
  }

  SliverGrid _buildPopularRestaurant() {
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.6),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return product.data.length > 0
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailScreen(
                                id: product.data[index].id.toString(),
                              )),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SizedBox(
                      width: (140),
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
                            product.data[index].formatedSpecialPrice
                                        .toString()
                                        .isNotEmpty &&
                                    product.data[index].Discount_Percentage
                                            .toString() !=
                                        "null"
                                ? Badge(
                                    badgeContent: Text(
                                      product.data[index].Discount_Percentage
                                              .toString()
                                              .substring(
                                                  0,
                                                  product.data[index]
                                                      .Discount_Percentage
                                                      .toString()
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
                                            getProportionateScreenWidth(20)),

                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
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
                                              .data[index].images![0].url
                                              .toString(),
                                          placeholder: (context, url) =>
                                              new Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors
                                                                  .amberAccent[
                                                              400])),
                                          errorWidget: (context, url, error) =>
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
                                            bottomRight: Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
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
                                            .data[index].images![0].url
                                            .toString(),
                                        placeholder: (context, url) =>
                                            new Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors
                                                            .amberAccent[400])),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/Placeholders.png',
                                        ),
                                      ),
                                      // ),
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            Flexible(
                              child: Container(
                                child: Center(
                                    child: Text(
                                  product.data[index].name.toString(),
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'Roboto',
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                product.data[index].formatedSpecialPrice
                                            .toString()
                                            .isNotEmpty &&
                                        product.data[index].formatedSpecialPrice
                                                .toString() !=
                                            "null"
                                    ? Column(children: [
                                        Text(
                                            product.data[index].formatedPrice
                                                .toString(),
                                            style: TextStyle(
                                                decoration: TextDecoration
                                                    .lineThrough)),
                                        Text(
                                          product
                                              .data[index].formatedSpecialPrice
                                              .toString(),
                                          style: TextStyle(
                                            color: HexColor(
                                                getjson.banner[0].primaryColor),
                                            fontSize:
                                                getProportionateScreenWidth(14),
                                            fontWeight: FontWeight.w600,
                                            // color: HexColor(getjson.banner[0].primaryColor),
                                          ),
                                        ),
                                      ])
                                    : Text(
                                        product.data[index].formatedPrice
                                            .toString(),
                                        style: TextStyle(
                                          color: HexColor(
                                              getjson.banner[0].primaryColor),
                                          fontSize:
                                              getProportionateScreenWidth(14),
                                          fontWeight: FontWeight.w600,
                                          // color: HexColor(getjson.banner[0].primaryColor),
                                        ),
                                      ),
                                if (1 != "null") ...[
                                  InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () async {
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      String userID = preferences
                                          .getString("UserID")
                                          .toString();

                                      if (userID == "null") {
                                        // Fluttertoast.showToast(
                                        //     msg:
                                        //         "Please Login to add to wishlist");
                                        Navigator.pushNamed(
                                            context, SignInScreen.routeName);
                                      } else {
                                        String token = preferences
                                            .getString("loggedIntoken")
                                            .toString();

                                        dynamic data =
                                            await APIService.WishlistItem(
                                                product.data[index].id
                                                    .toString(),
                                                userID,
                                                token);
                                        Fluttertoast.showToast(
                                            msg: data['message'].toString());
                                        setState(() {
                                          getData(id);
                                        });
                                        _asyncLoaderState.currentState!
                                            .reloadState();
                                        // setState(() {});
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all((8)),
                                      height: (28),
                                      width: (28),
                                      decoration: BoxDecoration(
                                        color: true
                                            ? HexColor(getjson
                                                    .banner[0].primaryColor)
                                                .withOpacity(0.15)
                                            : kSecondaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        Theme_Settings.HeartIcon,
                                        color: product.data[index].isWishlisted
                                            ? Color(0xFFFF4848)
                                            : Color(0xFFDBDEE4),
                                      ),
                                    ),
                                  ),
                                ],
                                InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () async {
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    String userID = preferences
                                        .getString("UserID")
                                        .toString();

                                    if (userID == "null") {
                                      AddToCartModel cartModel =
                                          new AddToCartModel(
                                              productId: product.data[index].id
                                                  .toString(),
                                              quantity: "1");
                                      dynamic data = await APIService.AddToCart(
                                          cartModel, "");

                                      Fluttertoast.showToast(
                                          msg: data['message'].toString());
                                    } else {
                                      AddToCartModel cartModel =
                                          new AddToCartModel(
                                              productId: product.data[index].id
                                                  .toString(),
                                              quantity: "1");
                                      dynamic data = await APIService.AddToCart(
                                          cartModel,
                                          preferences
                                              .getString('loggedIntoken')
                                              .toString());
                                      print(data);

                                      // CartModel cartResponseModel =
                                      //     CartModel.fromJson(json.decode(data));

                                      Fluttertoast.showToast(
                                          msg: data['message'].toString());
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all((8)),
                                    height: (28),
                                    width: (28),
                                    decoration: BoxDecoration(
                                      color: true
                                          ? HexColor(getjson
                                                  .banner[0].primaryColor)
                                              .withOpacity(0.15)
                                          : kSecondaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      Theme_Settings.HomeHeaderCartIcon,
                                      // color: product.data[index].isWishlisted
                                      //     ? Color(0xFFFF4848)
                                      //     : Color(0xFFDBDEE4),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
              : Center(
                  child: Text("No Product Found"),
                );
        }, childCount: product.data.length));
  }

  static const TIMEOUT = const Duration(seconds: 5);

  getMessage() async {
    return new Future.delayed(TIMEOUT, () => {});
  }
}
