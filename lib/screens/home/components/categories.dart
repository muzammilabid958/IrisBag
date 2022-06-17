import 'dart:convert';

import 'package:IrisBag/constants.dart';
import 'package:IrisBag/models/widgetjson.dart';
import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/models/Categories.dart';
import 'package:IrisBag/models/DescendantCategory.dart';
import 'package:IrisBag/screens/home/components/sub_category.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:IrisBag/models/SubCategory.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../size_config.dart';
import 'package:awesome_loader/awesome_loader.dart';

class Categories extends StatefulWidget {
  static String routeName = "/category";
  final setCatID;
  const Categories({Key? key, this.setCatID}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late DescendantCategory categoryeee = new DescendantCategory(data: []);

  @override
  void initState() {
    // TODO: implement initState

    getCategoryData();
    readJson();
  }

  late widgetjson getjson;
  readJson() async {
    final data = await APIService.jsonfile();
    getjson = widgetjson.fromJson(data);
    setState(() {
      getjson = widgetjson.fromJson(data);
    });
  }

  getCategoryData() async {
    dynamic data = await APIService.descendantCategories();
    categoryeee = DescendantCategory.fromJson(data);

    widget.setCatID(categoryeee.data[0].id.toString());
  }

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  static const TIMEOUT = const Duration(seconds: 5);

  getMessage() async {
    return new Future.delayed(TIMEOUT, () => {});
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
        renderSuccess: ({data}) => Column(
              children: [
                SizedBox(height: getProportionateScreenWidth(20)),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0; i < categoryeee.data.length; i++) ...[
                          GestureDetector(
                              onTap: () {
                                widget.setCatID(
                                    categoryeee.data[i].id.toString());
                              },
                              child: SizedBox(
                                  width: getProportionateScreenWidth(80),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          height:
                                              getProportionateScreenWidth(30),
                                          width:
                                              getProportionateScreenWidth(30),
                                          child: SvgPicture.network(
                                            categoryeee.data[i].categoryIconPath
                                                .toString(),
                                            width: 40,
                                            color: getjson.banner.length > 0
                                                ? HexColor(
                                                    getjson.banner[0].iconColor)
                                                : HexColor(kPrimaryColor),
                                            height: 20,
                                            allowDrawingOutsideViewBox: true,
                                            placeholderBuilder: (context) =>
                                                Container(
                                                    decoration:
                                                        const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/Placeholders.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  width: 1.0,
                                                  color: getjson.banner.length >
                                                          0
                                                      ? HexColor(getjson
                                                          .banner[0]
                                                          .primaryColor)
                                                      : HexColor(kPrimaryColor),
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 5, 0, 5),
                                                child: Text(
                                                    categoryeee.data[i].name
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                    textAlign:
                                                        TextAlign.center)))
                                      ])))
                        ],
                        SizedBox(width: getProportionateScreenWidth(20)),
                      ],
                    )),
              ],
            ));
    return _asyncLoader;
  }
}
