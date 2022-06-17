import 'dart:convert';

import 'package:IrisBag/screens/sign_in/sign_in_screen.dart';
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
import 'package:IrisBag/models/searchProduct.dart';
import 'package:IrisBag/screens/details/details_screen.dart';
import 'package:IrisBag/size_config.dart';
import 'package:awesome_loader/awesome_loader.dart';
import '../../constants.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import '../../models/CategoryProduct.dart';
import '../../models/widgetjson.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:badges/badges.dart';

class SearchedProduct extends StatefulWidget {
  String query;

  SearchedProduct({Key? key, required this.query}) : super(key: key);

  @override
  _SearchedProductState createState() => _SearchedProductState(this.query);
}

class _SearchedProductState extends State<SearchedProduct> {
  String query;

  CategoryProduct product = new CategoryProduct(data: []);

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  _SearchedProductState(this.query);
  static const TIMEOUT = const Duration(seconds: 5);

  getMessage() async {
    return new Future.delayed(TIMEOUT, () => {});
  }

  searchProduct(String query) async {
    dynamic data = await APIService.searchProduct(query);
    print(data);
    product = new CategoryProduct.fromJson(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    // Fluttertoast.showToast(msg: query);

    searchProduct(query);
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

  double _lowerValue = 50;
  double _upperValue = 180;
  @override
  Widget build(BuildContext context) {
    Widget child;
    var _asyncLoader = AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getMessage(),
      renderLoad: () => Center(
          child: AwesomeLoader(
        loaderType: AwesomeLoader.AwesomeLoader3,
        color: HexColor(Theme_Settings.loaderColor['color']),
      )),
      renderError: ([error]) => Text('Something Went Wrong'),
      renderSuccess: ({data}) => product.data.length > 0
          ? CustomScrollView(slivers: <Widget>[
              _buildPopularRestaurant(),
              // _buildPopularRestaurant(),
            ])
          : Center(
              child: Column(children: [
                EmptyWidget(
                  image: null,
                  packageImage: PackageImage.Image_1,
                  title: 'Seaching Product',
                  subTitle: 'No  Product Available yet',
                  titleTextStyle: TextStyle(
                    fontSize: 22,
                    color: Color(0xff9da9c7),
                    fontWeight: FontWeight.w500,
                  ),
                  subtitleTextStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xffabb8d6),
                  ),
                )
              ]),
            ),
    );
    return Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text(
            "Search for " + this.query,
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
                                                decoration:
                                                    TextDecoration.overline)),
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
                                          // getData(id);
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
}

class Filtre extends StatefulWidget {
  @override
  _FiltreState createState() => _FiltreState();
}

class _FiltreState extends State<Filtre> {
  double _lowerValue = 60;
  double _upperValue = 1000;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Reset"),
              Text("Filters"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              color: Colors.black26,
              height: 2,
            ),
          ),
          SingleChildScrollView(
            child: Row(
              children: <Widget>[
                buildChip("American", Colors.grey.shade400, "A",
                    Colors.grey.shade600),
                buildChip("Turkish", Theme.of(context).primaryColor, "A",
                    Theme.of(context).primaryColor),
                buildChip(
                    "Asia", Colors.grey.shade400, "A", Colors.grey.shade600),
                buildChip(
                    "Europe", Colors.grey.shade400, "A", Colors.grey.shade600),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              buildChip(
                  "Lorem", Colors.grey.shade400, "A", Colors.grey.shade600),
              buildChip(
                  "Ipsum", Colors.grey.shade400, "A", Colors.grey.shade600),
              buildChip(
                  "Dolır", Colors.grey.shade400, "A", Colors.grey.shade600),
              buildChip(
                  "Sit amed", Colors.grey.shade400, "A", Colors.grey.shade600),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("SORT BY"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Top Rated",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Divider(
              color: Colors.black26,
              height: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Nearest Me"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Divider(
              color: Colors.black26,
              height: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Cost Hight to Low"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Divider(
              color: Colors.black26,
              height: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Cost Low to Hight"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Divider(
              color: Colors.black26,
              height: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 8.0, left: 8.0, right: 8.0),
            child: Text("PRICE"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("\$ " + '$_lowerValue'),
                Text("\$ " + '$_upperValue'),
              ],
            ),
          ),
          FlutterSlider(
            tooltip: FlutterSliderTooltip(
              leftPrefix: Icon(
                Icons.attach_money,
                size: 19,
                color: Colors.black45,
              ),
              rightSuffix: Icon(
                Icons.attach_money,
                size: 19,
                color: Colors.black45,
              ),
            ),
            trackBar: FlutterSliderTrackBar(
              inactiveTrackBar: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black12,
                border: Border.all(width: 3, color: Colors.blue),
              ),
              activeTrackBar: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.red.withOpacity(0.5)),
            ),
            values: [30, 420],
            rangeSlider: true,
            max: 500,
            min: 0,
            onDragging: (handlerIndex, lowerValue, upperValue) {
              _lowerValue = lowerValue;
              _upperValue = upperValue;
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  Padding buildChip(
      String label, Color color, String avatarTitle, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, right: 2.0, left: 2.0),
      child: FilterChip(
        padding: EdgeInsets.all(4.0),
        label: Text(
          label,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.transparent,
        shape: StadiumBorder(
          side: BorderSide(color: color),
        ),
        onSelected: (bool value) {
          print("selected");
        },
      ),
    );
  }
}
