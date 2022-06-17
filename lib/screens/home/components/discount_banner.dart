import 'dart:convert';

import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/models/Banner.dart';
import 'package:IrisBag/models/widgetjson.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../size_config.dart';
import './../../../settings/settings.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:async_loader/async_loader.dart';
import 'package:awesome_loader/awesome_loader.dart';

class DiscountBanner extends StatefulWidget {
  const DiscountBanner({Key? key}) : super(key: key);

  @override
  _DiscountBannerState createState() => _DiscountBannerState();
}

class _DiscountBannerState extends State<DiscountBanner> {
  widgetjson getjson = new widgetjson(banner: []);
  Bannertext bannertext = Bannertext(data: Data(mainText: '', subText: ''));

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  static const TIMEOUT = const Duration(seconds: 5);

  getMessage() async {
    return new Future.delayed(TIMEOUT, () => {});
  }

  @override
  void initState() {
    readJson();

    getDiscountBanner();
  }

  readJson() async {
    final data = await APIService.jsonfile();
    setState(() {
      getjson = widgetjson.fromJson(data);
    });
  }

  getDiscountBanner() async {
    dynamic data = await APIService.bannertext();

    setState(() {
      bannertext = Bannertext.fromJson(data);
    });
  }

  final GlobalKey<AsyncLoaderState> _asyncLoaderStates =
      new GlobalKey<AsyncLoaderState>();
  @override
  Widget build(BuildContext context) {
    var _asyncLoader = AsyncLoader(
        key: _asyncLoaderStates,
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
        renderSuccess: ({data}) => Container(
              // height: 90,
              width: double.infinity,
              margin: EdgeInsets.all(getProportionateScreenWidth(15)),
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15),
                vertical: getProportionateScreenWidth(10),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    // Colors.black,
                    // Colors.black,
                    // Colors.black,
                    HexColor(getjson.banner[0].CashBackColor),
                    HexColor(getjson.banner[0].CashBackColor),
                    HexColor(getjson.banner[0].CashBackColor),
                  ],
                ),

                // color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  textBaseline: TextBaseline.alphabetic,
                  textDirection: TextDirection.ltr,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(color: Theme_Settings.colorWhite),
                        children: [
                          TextSpan(
                              text: bannertext.data.mainText.toString(),
                              style: Theme_Settings.A_Summer_Surpise_Style),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(color: Theme_Settings.colorWhite),
                        children: [
                          TextSpan(
                              text: bannertext.data.subText.toString(),
                              style: Theme_Settings.CashbackStyle),
                        ],
                      ),
                    )
                  ]),
            ));
    return _asyncLoader;
  }
}
