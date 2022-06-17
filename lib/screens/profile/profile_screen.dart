import 'package:IrisBag/constant/api_services.dart';
import 'package:flutter/material.dart';
import 'package:IrisBag/components/coustom_bottom_nav_bar.dart';
import 'package:IrisBag/enums.dart';

import '../../models/widgetjson.dart';
import 'components/body.dart';
import 'package:IrisBag/models/configPage.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static String routeName = "/profile";

  widgetjson getjson = new widgetjson(banner: []);
  readJson() async {
    final data = await APIService.jsonfile();
    getjson = widgetjson.fromJson(data);
    setState(() {
      getjson = widgetjson.fromJson(data);
    });
  }

  @override
  void initState() {
    super.initState();
 
    readJson();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          Navigator.of(context).pushNamed('/home');
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Profile"),
          ),
          body: Body(),
          bottomNavigationBar:
              CustomBottomNavBar(selectedMenu: MenuState.profile),
        ));
  }
}
