import 'dart:convert';

import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/screens/category/category_screen.dart';
import 'package:IrisBag/screens/home/components/categories.dart';
import 'package:IrisBag/screens/home/home_screen.dart';
import 'package:IrisBag/screens/profile/profile_screen.dart';
import 'package:IrisBag/screens/wishlistproducts/wishlist_product.dart';
import 'package:hexcolor/hexcolor.dart';
import '../constants.dart';
import '../enums.dart';
import '../models/widgetjson.dart';
import 'package:async_loader/async_loader.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:IrisBag/models/configPage.dart';

import '../screens/sign_in/sign_in_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  final MenuState selectedMenu;
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  @override
  _CustomBottomNavBarState createState() =>
      _CustomBottomNavBarState(this.selectedMenu);
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  widgetjson getjson = widgetjson(banner: []);

  _CustomBottomNavBarState(
    this.selectedMenu,
  );

  final MenuState selectedMenu;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  static const TIMEOUT = const Duration(seconds: 5);

  getMessage() async {
    return new Future.delayed(TIMEOUT, () => {});
  }

  readJson() async {
    final data = await APIService.jsonfile();
    getjson = widgetjson.fromJson(data);
    setState(() {
      getjson = widgetjson.fromJson(data);
    });
  }

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);

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
        renderSuccess: ({data}) => Container(
              padding: EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: getjson.banner.isNotEmpty
                    ? HexColor(getjson.banner[0].bottomBarColor)
                    : HexColor(kPrimaryColor),
                // color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -15),
                    blurRadius: 20,
                    color: getjson.banner.isNotEmpty
                        ? HexColor(getjson.banner[0].bottomBarColor)
                            .withOpacity(0.15)
                        : HexColor(kPrimaryColor),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          Theme_Settings.iconBottomBar['home_icon'],
                          color: MenuState.home == selectedMenu
                              ? HexColor(getjson.banner[0].iconColor)
                              : inActiveIconColor,
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, HomeScreen.routeName),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          Theme_Settings.iconBottomBar['favorite_icon'],
                          color: MenuState.favourite == selectedMenu
                              ? getjson.banner.isNotEmpty
                                  ? HexColor(getjson.banner[0].iconColor)
                                  : HexColor(kPrimaryColor)
                              : inActiveIconColor,
                        ),
                        onPressed: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();

                          String userid =
                              preferences.getString("loggedIntoken").toString();

                          if (userid == "null") {
                            // Fluttertoast.showToast(msg: "Please Login");
                            Navigator.pushNamed(
                                context, SignInScreen.routeName);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WishListProduct()));
                          }
                        },
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          Theme_Settings.iconBottomBar['category_icon'],
                          color: MenuState.category == selectedMenu
                              ? getjson.banner.isNotEmpty
                                  ? HexColor(getjson.banner[0].iconColor)
                                  : HexColor(kPrimaryColor)
                              : inActiveIconColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryScreen()),
                          );
                        },
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          Theme_Settings.iconBottomBar['user_icon'],
                          color: MenuState.profile == selectedMenu
                              ? getjson.banner.isNotEmpty
                                  ? HexColor(getjson.banner[0].iconColor)
                                  : HexColor(kPrimaryColor)
                              : inActiveIconColor,
                        ),
                        onPressed: () => Navigator.pushNamed(
                            context, ProfileScreen.routeName),
                      ),
                    ],
                  )),
            ));
    return _asyncLoader;
  }
}
