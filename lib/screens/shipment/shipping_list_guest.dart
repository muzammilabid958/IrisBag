import 'dart:convert';

import 'package:IrisBag/constants.dart';
import 'package:IrisBag/models/ShippingForGuest.dart' as obj;
import 'package:IrisBag/screens/shipment/payment_method_guest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_alertdialog/material_alertdialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/payment/payment_screen.dart';
import 'package:IrisBag/screens/shipment/payment_method.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/ShippingForGuest.dart';
import '../../models/widgetjson.dart';
import 'package:hexcolor/hexcolor.dart';

class ShippingListGuest extends StatefulWidget {
  static String routeName = "/shipping_list";
  ShippmentForGuest data;
  ShippingListGuest({Key? key, required this.data}) : super(key: key);

  @override
  _ShippingListGuestState createState() => _ShippingListGuestState(data);
}

class _ShippingListGuestState extends State<ShippingListGuest> {
  late SharedPreferences prefs;

  widgetjson getjson = new widgetjson(banner: []);
  ShippmentForGuest data;
  _ShippingListGuestState(this.data);
  readJson() async {
    final data = await APIService.jsonfile();
    getjson = widgetjson.fromJson(data);
    setState(() {
      getjson = widgetjson.fromJson(data);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Shipping Method",
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(15),
                child: Column(children: [
                  for (var i = 0; i < data.data.rate.length; i++) ...[
                    for (var j = 0;
                        j < data.data.rate[i].rates.length;
                        j++) ...[
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
                                Container(
                                  margin: EdgeInsets.all(15),
                                  width: 400,
                                  child: Text(
                                    data.data.rate[i].rates[j].carrierTitle,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(15),
                                  child: Text(
                                    data.data.rate[i].rates[j].formatedPrice
                                        .toString(),
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
                                      color: getjson.banner.length > 0
                                          ? HexColor(
                                              getjson.banner[0].primaryColor)
                                          : HexColor(kPrimaryColor),
                                      onPressed: () async {
                                        String name = data
                                            .data.rate[i].rates[j].method
                                            .toString();

                                        dynamic apidata =
                                            await APIService.SaveShipping(
                                                name, "");
                                        print("Shipping Method Woekirn");
                                        print(apidata);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => PaymentForGuest(
                                                    paymentdata: apidata)));
                                      },
                                    ))
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                    ]
                  ]
                ]))));
  }
}
