import 'dart:convert';
import 'dart:io';
import 'package:IrisBag/models/widgetjson.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/constants.dart';
import 'package:IrisBag/models/slide.dart';
import 'package:IrisBag/screens/complete_profile/complete_profile_screen.dart';
import 'package:IrisBag/screens/home/home_screen.dart';
import 'package:IrisBag/screens/sign_in/sign_in_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:IrisBag/size_config.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_loader/awesome_loader.dart';
// This is the best practice
import '../../../constant/api_services.dart';
import '../../../settings/settings.dart';
import '../../../settings/theme_json.dart';
import '../components/splash_content.dart';
import '../../../components/default_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // String _connectionStatus = 'Unknown';
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final PageController _pageController = PageController(initialPage: 1);
  int _currentPage = 0;
  final Connectivity _connectivity = Connectivity();
  int userID = 0;
  Map _source = {ConnectivityResult.none: false};
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      Fluttertoast.showToast(msg: 'onMessageOpenedApp data: ${message!.data}');
    });

    Timer(const Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });






    
    super.initState();
    getData();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    getToken();
    readJson();
  }

  ConnectivityResult result = ConnectivityResult.none;
  String _connectionStatus = 'Unknown';

  widgetjson getjson = new widgetjson(banner: []);
  readJson() async {
    final data = await APIService.jsonfile();
    getjson = widgetjson.fromJson(data);
    setState(() {
      getjson = widgetjson.fromJson(data);
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    print("Notification Token");
    print(token);
  }

  Future<void> initConnectivity() async {
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Exception");
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
    if (result == ConnectivityResult.none) {
      Fluttertoast.showToast(
          msg: "Internet Disconnected,Please check your connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {}
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("UserID").toString().isNotEmpty ||
        preferences.getString("UserID").toString() != "null") {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        //result != _connectivityResult.none ?
        SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Expanded(
              flex: 1,
              child: Container(
                  margin: EdgeInsets.only(bottom: 0),
                  child: Image.asset(
                    'assets/images/image.png',
                    width: 250,
                    height: 190,
                  )),
            ),
            Text(
              'Handbags & Accessories',
              style: GoogleFonts.satisfy(
                fontSize: 25,
              ),
            ),
            Expanded(
              flex: 1,
              child: AwesomeLoader(
                loaderType: AwesomeLoader.AwesomeLoader4,
                color: HexColor(Theme_Settings.loaderColor['color']),
              ),
            )
          ],
        ),
      ),
    );
    //:Center(child: Text('Connection Status: $_connectionStatus'));
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: _currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? HexColor(getjson.banner[0].primaryColor)
            : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
