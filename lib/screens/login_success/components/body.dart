import 'package:flutter/material.dart';
import 'package:IrisBag/components/default_button.dart';
import 'package:IrisBag/screens/home/home_screen.dart';
import 'package:IrisBag/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Image.asset(
          "assets/images/iris.png",
          width: 700,
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        Text(
          "Login Success",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: "Back to home",
            press: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
        ),
        Spacer(),
      ],
    ));
  }
}
