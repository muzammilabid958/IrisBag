import 'dart:convert';

import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/models/filterid.dart';
import 'package:IrisBag/screens/details/details_screen.dart';
import 'package:IrisBag/screens/sign_in/sign_in_screen.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../models/AddToCart.dart';
import '../../models/FilteredProduct.dart';
import '../../models/widgetjson.dart';
import '../../size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:async_loader/async_loader.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:badges/badges.dart';

class ShowFilterData extends StatefulWidget {
  List<String> id;
  List<String> price;
  ShowFilterData({Key? key, required this.id, required this.price})
      : super(key: key);

  @override
  _ShowFilterDataState createState() =>
      _ShowFilterDataState(this.id, this.price);
}

class _ShowFilterDataState extends State<ShowFilterData> {
  late List<String> id = [];
  late List<String> price = [];
  _ShowFilterDataState(this.id, this.price);
  late FilteredProduct product = new FilteredProduct(data: []);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // filterid selectedids = new filterid();

    // getData(selectedids);
    getData();
    print("Length");
    print(product.data.length);
    readJson();
  }

  late widgetjson getjson;
  readJson() async {
    // final String response =
    //     await rootBundle.loadString('assets/widgetjson.json');
    // final data = await json.decode(response);
    // setState(() {
    //   getjson = widgetjson.fromJson(data);
    // });
    final data = await APIService.jsonfile();
    getjson = widgetjson.fromJson(data);
    setState(() {
      getjson = widgetjson.fromJson(data);
    });
  }

  getData() async {
    List<String> c = [];
    List<String> priceList = [];
    String selectedid = "";
    String selectedprice = "";

    if (id.isNotEmpty) {
      for (var i = 0; i < id.length; i++) {
        selectedid = selectedid + id[i].toString() + ",";
      }
      c = selectedid.split("");
      c.removeLast();
    }
    if (price.isNotEmpty) {
      for (var i = 0; i < price.length; i++) {
        selectedprice = selectedprice + price[i].toString() + ",";
      }
      priceList = selectedprice.split("");
      priceList.removeLast();
    }

    dynamic data = await APIService.getFilteredProduct(
        filterid(c.join().toString(), priceList.join().toString()));

    if (data != null) {
      setState(() {
        product = FilteredProduct.fromJson(data);
      });
    }
  }

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  @override
  Widget build(BuildContext context) {
    Widget child;
    var _asyncLoader = AsyncLoader(
        key: _asyncLoaderState,
        initState: () async => await getMessage(),
        renderLoad: () => Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: CircularProgressIndicator())
                ])),
        renderError: ([error]) => new Text('Something Went Wrong'),
        renderSuccess: ({data}) => product.data.length > 0
            ? CustomScrollView(slivers: <Widget>[
                _buildPopularRestaurant(),
                // _buildPopularRestaurant(),
              ])
            : Center(
                child: Text("No Product Found"),
              ));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [],
          title: Text(
            "Filtered Product",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: _asyncLoader);
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
                                              .data[index].images[0].url
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
                                            .data[index].images[0].url
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
                                Flexible(
                                  child: Container(
                                    child: Center(
                                        child: Text(
                                      product.data[index].formatedPrice
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: new TextStyle(
                                        fontSize: 13.0,
                                        fontFamily: 'Roboto',
                                        color: new Color(0xFF212121),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
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
                                          getData();
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
