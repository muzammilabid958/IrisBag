import 'dart:async';

import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/components/custom_surfix_icon.dart';
import 'package:IrisBag/components/default_button.dart';
import 'package:IrisBag/components/form_error.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/constant/config.dart';
import 'package:IrisBag/helper/keyboard.dart';
import 'package:IrisBag/models/ProfileModel.dart';
import 'package:IrisBag/models/ShippingAddress.dart';
import 'package:IrisBag/models/errorModel.dart';
import 'package:IrisBag/models/resultmodel.dart';
import 'package:IrisBag/screens/complete_profile/Getdetails.dart';
import 'package:IrisBag/screens/otp/otp_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:dropdown_formfield/dropdown_formfield.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [],
      ),
    );
  }
}
