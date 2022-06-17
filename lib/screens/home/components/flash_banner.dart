import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/models/HomeSlider.dart';
import 'package:IrisBag/models/Productss.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:async_loader/async_loader.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_loader/awesome_loader.dart';
import '../../../settings/settings.dart';
import '../../category/product_category_screen.dart';
import '../../category/sliderProduct.dart';
import '../../details/details_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'flash_sale.dart';

class FlashSaleBanner extends StatefulWidget {
  const FlashSaleBanner({Key? key}) : super(key: key);

  @override
  _FlashSaleBannerState createState() => _FlashSaleBannerState();
}

class _FlashSaleBannerState extends State<FlashSaleBanner> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCarsouel();
  }

  List<dynamic> list = [2];
  List<Productss> carosuel = [];
  late HomeSlider slider_Data;

  String link = "";
  getCarsouel() async {
    dynamic data = await APIService.flashHomePageSlider();
    print("flash sale");
    print(data);
    setState(() {
      slider_Data = HomeSlider.fromJson(data);

      link = slider_Data.data[0].imageUrl.toString();
    });
  }

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  getMessage() async {
    return new Future.delayed(TIMEOUT, () => {});
  }

  static const TIMEOUT = const Duration(seconds: 5);

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
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: AwesomeLoader(
                        loaderType: AwesomeLoader.AwesomeLoader3,
                        color: HexColor(Theme_Settings.loaderColor['color']),
                      ))
                ])),
        renderError: ([error]) => Text('Something Went Wrong'),
        renderSuccess: ({data}) => GestureDetector(
              onTap: () {},
              child: Container(
                width: 400,
                height: 300,
                child: CachedNetworkImage(
                  imageUrl: link,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fill),
                    ),
                  ),
                  placeholder: (context, url) => AwesomeLoader(
                    loaderType: AwesomeLoader.AwesomeLoader3,
                    color: HexColor(Theme_Settings.loaderColor['color']),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/Placeholders.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
        //         ],
        //       )),
        // ),
        //)

        );
    return _asyncLoader;
  }
}
