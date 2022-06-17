import 'package:flutter/material.dart';
import 'package:IrisBag/components/coustom_bottom_nav_bar.dart';
import 'package:IrisBag/enums.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'components/body.dart';

// class HomeScreen extends StatelessWidget {
//   static String routeName = "/home";

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//         onRefresh: () async {
//           Navigator.pushNamed(context, HomeScreen.routeName);
//         },
//         child: const Scaffold(
//           body: Body(),
//           bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
//         ));
//   }
// }

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          Navigator.pushNamed(context, HomeScreen.routeName);
        },
        child: const Scaffold(
          body: Body(),
          bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
        ));
  }
}
