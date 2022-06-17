import 'package:flutter/material.dart';
import 'package:IrisBag/screens/splash/components/body.dart';
import 'package:IrisBag/size_config.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: HexColor("#FFF1CA"),
      body: Body(),
    );
  }
}
