import 'dart:io';
import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/models/widgetjson.dart';
import 'package:IrisBag/screens/category/product_category_screen.dart';
import 'package:IrisBag/screens/serverError.dart';
import 'package:IrisBag/screens/sign_in/components/Authentication.dart';
import 'package:IrisBag/screens/sign_in/components/body.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:flutter/material.dart';
import 'package:IrisBag/routes.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:IrisBag/screens/splash/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/category/sliderProduct.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.high);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // if (message.data.isNotEmpty) {
  //   Fluttertoast.showToast(msg: "M" + message.data.length.toString());
  // } else {
  //   Fluttertoast.showToast(msg: "nio data");
  // }

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    Fluttertoast.showToast(msg: 'getInitialMessage data: ${message!.data}');
  });

  // onMessage: When the app is open and it receives a push notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Fluttertoast.showToast(msg: "onMessage data: ${message.data}");
  });

  // replacement for onResume: When the app is in the background and opened directly from the push notification.

  APIService.loaded_from_firebase = true;
}

String key = "is_product";
RemoteMessage? initialMessage;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  HttpOverrides.global = MyHttpOverrides();
  ThemeData themeData = await initializeThemeData();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(Provider<AppleSignInAvailable>.value(
      value: appleSignInAvailable, child: MyApp(themeData: themeData)));
}

Future<ThemeData> initializeThemeData() async {
  dynamic jsonData = await APIService.jsonfile();
  print(jsonData);
  widgetjson widget = widgetjson.fromJson(jsonData);

  return ThemeData(
    scaffoldBackgroundColor:
        HexColor(widget.banner[0].scaffoldBackgroundColor.toString()),
    appBarTheme: AppBarTheme(
      titleTextStyle: GoogleFonts.getFont(
          widget.banner[0].bodyText1.toString().isNotEmpty
              ? widget.banner[0].bodyText1.toString()
              : "Poppins",
          color: HexColor(widget.banner[0].textcolor1.toString())),
      color: HexColor(widget.banner[0].appbarbackgroundcolor.toString()),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: Colors.red),
    textTheme: TextTheme(
        button: GoogleFonts.getFont(
            widget.banner[0].bodyText1.toString().isNotEmpty
                ? widget.banner[0].bodyText1.toString()
                : "Poppins",
            color: HexColor(widget.banner[0].textcolor1.toString())),
        bodyText1: GoogleFonts.getFont(
            widget.banner[0].bodyText1.toString().isNotEmpty
                ? widget.banner[0].bodyText1.toString()
                : "Poppins",
            color: HexColor(widget.banner[0].textcolor1.toString())),
        bodyText2: GoogleFonts.getFont(
            widget.banner[0].bodyText2.toString().isNotEmpty
                ? widget.banner[0].bodyText2.toString()
                : "Poppins",
            color: HexColor(widget.banner[0].textcolour2.toString()))),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  final ThemeData? themeData;

  const MyApp({Key? key, this.themeData}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState(themeData);
}

class _MyAppState extends State<MyApp> {
  @override
  widgetjson getjson = widgetjson(banner: []);

  dynamic fontfamily1 = "Poppins";
  dynamic fontfamily2 = "Poppins";
  dynamic fontcolour;
  static dynamic themebackgroundcolor = "";
  dynamic appbarcolor;
  dynamic buttoncolor;

  final ThemeData? themeData;
  _MyAppState(this.themeData);

// = 0xFFFFFFFF;

  void initState() {


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Fluttertoast.showToast(msg: 'onMessageOpenedApp data: ${message.data}');
    });
    
    
    
    
    super.initState();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Fluttertoast.showToast(msg: message.data[0]);
    });
  }

  void iOS_Permission() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Fluttertoast.showToast(msg: message.data[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (APIService.loaded_from_firebase) {
      if (initialMessage!.data['slider_is'].toString() == 'is_flashsale') {}
      if (initialMessage!.data['slider_is'].toString() == 'category') {
        return Provider<AuthService>(
            create: (_) => AuthService(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Iris Bag',
              theme: themeData ?? ThemeData.dark(),
              home: CategoryAllProduct(
                id: initialMessage!.data['category_id'].toString(),
              ),
              builder: EasyLoading.init(),
              routes: routes,
              navigatorKey: NavigationService.navigationKey,
              onGenerateRoute: (RouteSettings settings) {
                print("settings");
                print(settings.name);
                switch (settings.name) {
                  case '/serverError':
                    return MaterialPageRoute(builder: (_) => serverError());
                  // case '/detail_screen':
                  //   return MaterialPageRoute(
                  //       builder: (_) => DetailScreen(message: settings.arguments));
                  default:
                    return null;
                }
              },
            ));
      }
    } else {
      return Provider<AuthService>(
          create: (_) => AuthService(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Iris Bag',
            theme: themeData ?? ThemeData.dark(),
            home: SplashScreen(),
            builder: EasyLoading.init(),
            routes: routes,
            navigatorKey: NavigationService.navigationKey,
          ));
    }

    return Provider<AuthService>(
        create: (_) => AuthService(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          routes: routes,
          builder: EasyLoading.init(),
          navigatorKey: NavigationService.navigationKey,
        ));
  }
}

Future<void> _firebasepushhandler(RemoteMessage message) async {
  print(message.data);
  print(message.notification!.title);
  print(message.notification!.body);

  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback = ((cert, host, port) => true);
  }
}
