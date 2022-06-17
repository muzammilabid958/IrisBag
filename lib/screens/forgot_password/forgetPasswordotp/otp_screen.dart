import 'package:flutter/material.dart';
import 'package:IrisBag/size_config.dart';

import 'components/body.dart';

class ForgetPasswordOtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: Body(),
    );
  }
}
