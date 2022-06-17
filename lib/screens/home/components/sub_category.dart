import 'dart:async';

import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/models/DescendantCategory.dart';
import 'package:IrisBag/screens/_partial/_sub_category_card.dart';
import 'package:IrisBag/screens/home/components/section_title.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:IrisBag/stuffs/sub_category.dart';
import 'package:awesome_loader/awesome_loader.dart';
import '../../../size_config.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../category/product_category_screen.dart';

class SubCategories extends StatefulWidget {
  static String routeName = "/category";

  SubCatId id;
  DescendantCategory subcat;
  SubCategories({Key? key, required this.id, required this.subcat})
      : super(key: key);

  @override
  _SubCategoriesState createState() => _SubCategoriesState(id, subcat);
}

class _SubCategoriesState extends State<SubCategories> {
  DescendantCategory categoryeee = DescendantCategory(data: []);

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      GlobalKey<AsyncLoaderState>();
  static const TIMEOUT = Duration(seconds: 5);

  // _SubCategoriesState();
  SubCatId cateid;
  DescendantCategory subcat;
  _SubCategoriesState(this.cateid, this.subcat);

  getMessage() async {
    return Future.delayed(TIMEOUT, () => {});
  }

  @override
  void initState() {
    // TODO: implement initState

    getCategoryData(cateid.catID.toString());
  }

  getCategoryData(String id) async {
    dynamic data = await APIService.SubCategories(id);
    setState(() {
      categoryeee = DescendantCategory.fromJson(data);
    });
    if (categoryeee.data.isEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryAllProduct(id: id),
          ));
    }
  }

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
                      child: AwesomeLoader(
                        loaderType: AwesomeLoader.AwesomeLoader3,
                        color: HexColor(Theme_Settings.loaderColor['color']),
                      ))
                ])),
        renderError: ([error]) => Text('Something Went Wrong'),
        renderSuccess: ({data}) => categoryeee.data.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: categoryeee.data.isNotEmpty
                    ? Row(
                        children: [
                          if (categoryeee.data.isNotEmpty) ...[
                            for (var i = 0;
                                i < categoryeee.data.length;
                                i++) ...[
                              CategoryCard(
                                icon: categoryeee.data[i].categoryIconPath
                                    .toString(),
                                text: categoryeee.data[i].name,
                                id: categoryeee.data[i].id.toString(),
                              ),
                            ],
                          ]
                        ],
                      )
                    : Center(
                        child: Text("Empty"),
                      ),
              )
            : Center(
                child: Text("Empty"),
              ));
    return _asyncLoader;
  }
}
