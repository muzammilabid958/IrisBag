import 'dart:convert';

import 'package:IrisBag/constants.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_alertdialog/material_alertdialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/payment/payment_screen.dart';
import 'package:IrisBag/screens/shipment/payment_method.dart';

import '../../models/widgetjson.dart';
import 'package:async_loader/async_loader.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:async_loader/async_loader.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:IrisBag/models/ShippingForUser';

class ShippingList extends StatefulWidget {
  static String routeName = "/shipping_list";

  ShippmentForUser data;
  ShippingList({Key? key, required this.data}) : super(key: key);

  @override
  _ShippingListState createState() => _ShippingListState(data);
}

class _ShippingListState extends State<ShippingList> {
  late SharedPreferences prefs;

  widgetjson getjson = new widgetjson(banner: []);
  ShippmentForUser data;
  _ShippingListState(this.data);
  readJson() async {
    final data = await APIService.jsonfile();
    getjson = widgetjson.fromJson(data);
    setState(() {
      getjson = widgetjson.fromJson(data);
    });
  }

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  static const TIMEOUT = Duration(seconds: 5);
  getMessage() async {
    return Future.delayed(TIMEOUT, () => {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        renderError: ([error]) => new Text('Something Went Wrong'),
        renderSuccess: ({data}) => Container(
            padding: EdgeInsets.all(15),
            child: Column(children: [
              Container(
                  padding: EdgeInsets.all(15),
                  // height: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 13,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      textBaseline: TextBaseline.alphabetic,
                      textDirection: TextDirection.ltr,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // ListTile(
                        //   leading: Icon(Icons.home),
                        //   title: Text(address.data[index].city.toString()),
                        //   subtitle:
                        //       Text(address.data[index].country.toString()),
                        // ),
                        Container(
                          margin: EdgeInsets.all(15),
                          width: 400,
                          child: Text(
                            "Flat",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          child: Text(
                            "PKR 30",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),

                        Container(
                            margin: EdgeInsets.all(15),
                            width: 100,
                            height: 40,
                            child: RaisedButton(
                              child: Text(
                                "Select",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              color: HexColor(getjson.banner[0].primaryColor),
                              onPressed: () async {
                                prefs = await SharedPreferences.getInstance();
                                dynamic data = await APIService.SaveShipping(
                                    "flatrate_flatrate",
                                    prefs
                                        .getString("loggedIntoken")
                                        .toString());
                                print("Shipping Method Woekirn");
                                print(data);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PaymentMethod()));
                              },
                            ))
                      ],
                    ),
                  )),
              SizedBox(
                height: 30,
              ),
              Container(
                  padding: EdgeInsets.all(15),
                  // height: 200,

                  child: Card(
                      elevation: 13,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          textBaseline: TextBaseline.alphabetic,
                          textDirection: TextDirection.ltr,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(15),
                              width: 400,
                              child: Text(
                                "Free",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(15),
                              child: Text(
                                "PKR 0",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.all(15),
                                width: 100,
                                height: 40,
                                child: RaisedButton(
                                  child: Text(
                                    "Select",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  color:
                                      HexColor(getjson.banner[0].primaryColor),
                                  onPressed: () async {
                                    prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString(
                                        "ShippingMethod", "free_free");
                                    // print("Shipping Method Woekirn");
                                    dynamic data =
                                        await APIService.SaveShipping(
                                            "free_free",
                                            prefs
                                                .getString("loggedIntoken")
                                                .toString());

                                    // print(data);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => PaymentMethod()));
                                  },
                                ))
                          ],
                        ),
                      ))),
            ])));
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Shipping Method",
          ),
        ),
        body: _asyncLoader);
  }
}
