import 'dart:convert';

import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/models/widgetjson.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import '../constants.dart';
import '../size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:async_loader/async_loader.dart';
import 'package:awesome_loader/awesome_loader.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
    this.primaryColor,
  }) : super(key: key);
  final String? text;
  final Function? press;
  final String? primaryColor;

  @override
  _DefaultButtonState createState() => _DefaultButtonState(
        this.text,
        this.press,
        this.primaryColor,
      );
}

class _DefaultButtonState extends State<DefaultButton> {
  final String? text;
  final Function? press;
  final String? primaryColor;
  _DefaultButtonState(
    this.text,
    this.press,
    this.primaryColor,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  static const TIMEOUT = const Duration(seconds: 5);

  getMessage() async {
    return new Future.delayed(TIMEOUT, () => {});
  }

  widgetjson getjson = new widgetjson(banner: []);
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
        renderSuccess: ({data}) => SizedBox(
              width: double.infinity,
              height: getProportionateScreenHeight(56),
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  primary: Colors.white,
                  backgroundColor: getjson.banner[0].primaryColor.isEmpty ||
                          getjson.banner[0].primaryColor.toString() == "null"
                      ? HexColor(kPrimaryColor)
                      : HexColor(getjson.banner[0].primaryColor),
                ),
                onPressed: press as void Function()?,
                child: Text(
                  text!,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.white,
                  ),
                ),
              ),
            ));
    return _asyncLoader;
  }
}
