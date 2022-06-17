import 'dart:developer';
import 'dart:convert';
import 'package:IrisBag/models/ForgetPasswordUpdate.dart';
import 'package:IrisBag/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/components/custom_surfix_icon.dart';
import 'package:IrisBag/components/form_error.dart';
import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/helper/keyboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IrisBag/models/LoggedInUser.dart';
import 'package:IrisBag/models/login_model.dart';
import 'package:IrisBag/screens/forgot_password/forgot_password_screen.dart';
import 'package:IrisBag/screens/login_success/login_success_screen.dart';
import 'package:IrisBag/constant/config.dart';
import 'package:IrisBag/screens/sign_up/components/body.dart';
import '../../../../components/default_button.dart';
import '../../../../constants.dart';
import '../../../../size_config.dart';
import 'package:hexcolor/hexcolor.dart';

@override
Widget build(BuildContext context) {
  return Container();
}

class newpassword extends StatefulWidget {
  @override
  _newpasswordState createState() => _newpasswordState();
}

class _newpasswordState extends State<newpassword> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  bool? showpassword = false;
  bool hidepassword = true;
  // late LoginRequestModel requestModel;
//ate LoginRequestModel loginRequest;
  TextEditingController textpassword = new TextEditingController();
  TextEditingController retextpassword = new TextEditingController();

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: showpassword,
                activeColor: HexColor(kPrimaryColor),
                onChanged: (value) {
                  setState(() {
                    showpassword = value;
                    hidepassword = !hidepassword;
                  });
                },
              ),
              Text("Show Password"),
              Spacer(),
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
              text: "Continue",
              press: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (textpassword.text == retextpassword.text) {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    String email =
                        preferences.getString("ResetPasswordEmail").toString();
                    String password = textpassword.text.toString();

                    ForgetPasswordUpdateModel updateModel =
                        new ForgetPasswordUpdateModel(email, password);
                    dynamic data =
                        await APIService.UpdateForgetPassword(updateModel);
                    print(data['status']);
                    if (data['status'] == 200) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SignInScreen()));
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Password Does not Match ");
                  }
                }
              }),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: hidepassword,
      controller: textpassword,
      // onSaved: (value) => password =value ,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 6) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      obscureText: hidepassword,
      controller: retextpassword,
      // onSaved: (value) => password =value ,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 6) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Re-Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }
}
