import 'dart:convert';

import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/constants.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IrisBag/screens/category/product_category_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../models/widgetjson.dart';
import '../../size_config.dart';

// class CategoryCard extends StatelessWidget {
//   // final Data category;
//   final String icon;
//   final String text;
//   final String id;
//   CategoryCard({required this.icon, required this.text, required this.id});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     CategoryAllProduct(id: this.id.toString())),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Container(
//             width: 200,
//             height: 80,
//             child: Card(
//               color: HexColor(
//                   Theme_Settings.subCategoryCardHome[0]['color'].toString()),
//               // color: Colors.grey[100],
//               // color: Theme_Settings.subCategoryCardHome[0]['color'],
//               child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(5)),
//                 child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: <Color>[
//                           Colors.grey.shade50,
//                           Colors.grey.shade50,
//                           Colors.grey.shade50,
//                         ],
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey,
//                           spreadRadius: 18,
//                           blurRadius: 16,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                     child:
//                         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             // mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                           Flexible(
//                               child: Container(
//                                   child: Text(
//                             text,
//                             style: TextStyle(color: Color(0xfffc9918)),
//                             overflow: TextOverflow.ellipsis,
//                           ))),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => CategoryAllProduct(
//                                         id: this.id.toString())),
//                               );
//                             },
//                             child: Container(
//                               height: getProportionateScreenWidth(50),
//                               width: getProportionateScreenWidth(50),
//                               child: SvgPicture.network(
//                                 icon,
//                                 color: Color(0xfffc9918),
//                                 placeholderBuilder: (context) => Container(
//                                     height: 20,
//                                     width: 100,
//                                     child: Image(
//                                         height: 20,
//                                         image: new AssetImage(
//                                             'assets/images/Placeholders.png'))),
//                               ),
//                             ),
//                           )
//                         ])),
//               ),
//             ),
//           ),
//         ));
//   }
// }

class CategoryCard extends StatefulWidget {
  final String icon;
  final String text;
  final String id;
  CategoryCard({required this.icon, required this.text, required this.id});

  @override
  _CategoryCardState createState() =>
      _CategoryCardState(icon: this.icon, text: this.text, id: this.id);
}

class _CategoryCardState extends State<CategoryCard> {
  final String icon;
  final String text;
  final String id;
  _CategoryCardState(
      {required this.icon, required this.text, required this.id});
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
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CategoryAllProduct(id: this.id.toString())),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            width: 200,
            height: 80,
            child: Card(
              // color: Colors.grey[100],
              color: getjson.banner.length > 0
                  ? HexColor(getjson.banner[0].iconColor)
                  : HexColor(kPrimaryColor),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.grey.shade50,
                          Colors.grey.shade50,
                          Colors.grey.shade50,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 18,
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child:
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          Flexible(
                              child: Container(
                                  child: Text(
                            text,
                            // style: TextStyle(
                            //     color: HexColor(getjson.banner[0].iconColor)),
                            overflow: TextOverflow.ellipsis,
                          ))),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoryAllProduct(
                                        id: this.id.toString())),
                              );
                            },
                            child: Container(
                              height: getProportionateScreenWidth(50),
                              width: getProportionateScreenWidth(50),
                              child: SvgPicture.network(
                                icon,
                                color: getjson.banner.length > 0
                                    ? HexColor(getjson.banner[0].iconColor)
                                    : HexColor(kPrimaryColor),
                                placeholderBuilder: (context) => Container(
                                    height: 20,
                                    width: 100,
                                    child: Image(
                                        height: 20,
                                        image: new AssetImage(
                                            'assets/images/Placeholders.png'))),
                              ),
                            ),
                          )
                        ])),
              ),
            ),
          ),
        ));
  }
}
