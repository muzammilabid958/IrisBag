import 'dart:convert';
import 'dart:io';

import 'package:IrisBag/models/configPage.dart';
import 'package:IrisBag/screens/change_password/changepassword_screen.dart';
import 'package:IrisBag/screens/complete_profile/components/loader_profile.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/screens/complete_profile/complete_profile_screen.dart';
import 'package:IrisBag/screens/home/home_screen.dart';
import 'package:IrisBag/screens/orders/orders.dart';
import 'package:IrisBag/screens/shipment/shipment_screen.dart';
import 'package:IrisBag/screens/sign_in/sign_in_screen.dart';
import 'package:IrisBag/widget/alert_dialog.dart';

import '../../../models/widgetjson.dart';
import '../../config_pages/profile_screen.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:async_loader/async_loader.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:hexcolor/hexcolor.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with WidgetsBindingObserver {
  int userID = 0;
  String username = "";
  late SharedPreferences preferences;
  String profile = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addObserver(this);

    readJson();
    getData();
    getConfigPages();
  }

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  static const TIMEOUT = const Duration(seconds: 5);

  getMessage() async {
    return new Future.delayed(TIMEOUT, () => {});
  }

  ConfigPages configPages = new ConfigPages(data: []);
  getConfigPages() async {
    final data = await APIService.configpages();
    configPages = ConfigPages.fromJson(data);
    setState(() {
      configPages = ConfigPages.fromJson(data);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('AppLifecycleState: $state');
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("deactivate");
    super.deactivate();
  }

  getData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      print("fukcin");
      print(preferences.getString("UserID").toString());
      this.userID = int.parse(preferences.getString("name").toString() == "null"
          ? "0"
          : preferences.getString("UserID").toString());

      this.username = preferences.getString("name").toString() == "null"
          ? ""
          : preferences.getString("name").toString();
    });

    //Fluttertoast.showToast(msg: userID.toString());
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
        renderSuccess: ({data}) => SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  ProfilePic(),
                  SizedBox(height: 20),
                  Text(
                    username,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  if (userID > 0) ...[
                    ProfileMenu(
                      text: "My Account",
                      icon: Theme_Settings.profilePageIcon['MyAccount'],
                      press: () => {
                        Navigator.pushNamed(
                            context, CompleteProfileScreen.routeName)
                      },
                      color: getjson.banner.isNotEmpty
                          ? getjson.banner[0].iconColor
                          : "",
                    )
                  ],
                  if (userID > 0) ...[
                    ProfileMenu(
                      text: "My Order",
                      icon: Theme_Settings.profilePageIcon['MyOrder'],
                      press: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => OrderList()));
                      },
                      color: getjson.banner.isNotEmpty
                          ? getjson.banner[0].iconColor
                          : "",
                    )
                  ],
                  ProfileMenu(
                      text: "Support",
                      icon: Theme_Settings.profilePageIcon['Support'],
                      color: getjson.banner.isNotEmpty
                          ? getjson.banner[0].iconColor
                          : "",
                      press: () async {
                        final link = WhatsAppUnilink(
                          phoneNumber: '+923331203726',
                          text:
                              "Hey! I'm inquiring about the apartment listing",
                        );
                        // Convert the WhatsAppUnilink instance to a string.
                        // Use either Dart's string interpolation or the toString() method.
                        // The "launch" method is part of "url_launcher".
                        await launch('$link');
                      }),
                  if (userID > 0) ...[
                    ProfileMenu(
                      text: "Shiping",
                      icon: Theme_Settings.profilePageIcon['Shiping'],
                      color: getjson.banner.isNotEmpty
                          ? getjson.banner[0].iconColor
                          : "",
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ShipmentScreen()));
                      },
                    ),
                    if (preferences.getString("social").toString() != "1" ||
                        preferences.getString("social").toString().isEmpty) ...[
                      ProfileMenu(
                        text: "Change Password ",
                        color: getjson.banner.isNotEmpty
                            ? getjson.banner[0].iconColor
                            : "",
                        icon: Theme_Settings.profilePageIcon['ChangePassword'],
                        press: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChangePasssword()));
                        },
                      ),
                    ],
                    // else...[

                    ProfileMenu(
                      text: "Log Out",
                      color: getjson.banner.isNotEmpty
                          ? getjson.banner[0].iconColor
                          : "",
                      icon: Theme_Settings.profilePageIcon['LogOut'],
                      press: () async {
                        await AlertDialogs.yesCancelDialogue(
                            context, 'Logout', 'Are You Sure ?');
                      },
                    )
                  ] else ...[
                    ProfileMenu(
                      text: "Log In",
                      color: getjson.banner.isNotEmpty
                          ? getjson.banner[0].iconColor
                          : "",
                      icon: Theme_Settings.profilePageIcon['LogIn'],
                      press: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        dynamic data = APIService.Logout(
                            pref.getString("loggedIntoken").toString());
                        pref.clear();
                        Navigator.pushNamed(context, SignInScreen.routeName);
                      },
                    )
                  ],
                  for (var i = 0; i < configPages.data.length; i++) ...[
                    ProfileMenu(
                      text: configPages.data[i].PageName,
                      color: getjson.banner.isNotEmpty
                          ? getjson.banner[0].iconColor
                          : "",
                      icon: Theme_Settings.profilePageIcon['LogIn'],
                      press: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ConfigPagesView(
                                    pagetile:
                                        configPages.data[i].PageName.toString(),
                                    pagename: configPages.data[i].urlSlug
                                        .toString())));
                      },
                    )
                  ]
                  // ]
                ],
              ),
            ));
    return _asyncLoader;
  }
}
