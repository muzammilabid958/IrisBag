import 'dart:convert';
import 'dart:io';

import 'package:IrisBag/constant/api_services.dart';
import 'package:IrisBag/models/LoggedInUser.dart';
import 'package:IrisBag/models/facebookLogin.dart';
import 'package:IrisBag/models/googlelogin.dart';
import 'package:IrisBag/screens/login_success/login_success_screen.dart';
import 'package:IrisBag/screens/sign_in/components/Authentication.dart';
import 'package:IrisBag/screens/sign_in/sign_in_screen.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:IrisBag/components/no_account_text.dart';
import 'package:IrisBag/components/socal_card.dart';
import '../../../helper/keyboard.dart';
import '../../../size_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'sign_form.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;
  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await AppleSignIn.isAvailable());
  }
}

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isIOS) {
      //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _auth = Provider.of(context).auth;
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: Theme_Settings.socialIcon['google-icon'],
                      press: () async {
                        GoogleSignIn _googlesignin = GoogleSignIn();
                        try {
                          GoogleSignInAccount? result =
                              await _googlesignin.signIn();
                          String _googleUserEmail = result!.email;
                          if (result != null) {
                            GoogleSignInAuthentication _googleAuth =
                                await result.authentication;
                            print(_googleAuth);
                          } else {
                            return null;
                          }
                          print(result);

                          GoogleLoginModel googleLoginModel = GoogleLoginModel(
                              email: result.email,
                              firstName: '',
                              lastName: '',
                              isSocial: '1',
                              name: result.displayName!);
                          dynamic data =
                              await APIService.GoogleLogin(googleLoginModel);

                          if (data['status'] == 401) {
                            Fluttertoast.showToast(
                                msg: data['error'].toString());
                          }

                          LoggedInUser loggedInUser =
                              LoggedInUser.fromJson(data);
                          print("Profile Data Image" +
                              loggedInUser.data.profile.toString());
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences.setString(
                              "UserID", loggedInUser.data.id.toString());
                          preferences.setString(
                              "id", loggedInUser.data.id.toString());
                          preferences.setString(
                              "email", loggedInUser.data.email.toString());
                          preferences.setString("first_name",
                              loggedInUser.data.firstName.toString());
                          preferences.setString("last_name",
                              loggedInUser.data.lastName.toString());
                          preferences.setString(
                              "name", loggedInUser.data.name.toString());
                          preferences.setString("date_of_birth",
                              loggedInUser.data.dateOfBirth.toString());
                          preferences.setString(
                              "phone", loggedInUser.data.phone.toString());
                          preferences.setString(
                              "gender", loggedInUser.data.gender.toString());
                          preferences.setString(
                              "profile", loggedInUser.data.profile.toString());
                          preferences.setString("social", "1");
                          preferences.setString(
                              "loggedIntoken", loggedInUser.token.toString());
                          Navigator.pushNamed(
                              context, LoginSuccessScreen.routeName);
                        } catch (error) {
                          print("Error ");
                          print(error);
                        }
                      },
                    ),
                    SocalCard(
                      icon: Theme_Settings.socialIcon['facebook-icon'],
                      press: () async {
                        LoggedInUser loggedInUser = await loginWithfacebook();
                        print(loggedInUser.token);
                        if (loggedInUser.token != "") {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences.setString(
                              "UserID", loggedInUser.data.id.toString());
                          preferences.setString(
                              "id", loggedInUser.data.id.toString());
                          preferences.setString(
                              "email", loggedInUser.data.email.toString());
                          preferences.setString("first_name",
                              loggedInUser.data.firstName.toString());
                          preferences.setString("last_name",
                              loggedInUser.data.lastName.toString());
                          preferences.setString(
                              "name", loggedInUser.data.name.toString());
                          preferences.setString("date_of_birth",
                              loggedInUser.data.dateOfBirth.toString());
                          preferences.setString(
                              "phone", loggedInUser.data.phone.toString());
                          preferences.setString(
                              "gender", loggedInUser.data.gender.toString());
                          preferences.setString(
                              "profile", loggedInUser.data.profile.toString());
                          preferences.setString("social", "1");
                          preferences.setString(
                              "loggedIntoken", loggedInUser.token.toString());
                          Navigator.pushNamed(
                              context, LoginSuccessScreen.routeName);
                        }
                        //if (loggedInUser.message) {}
                      },
                    ),
                    if (Platform.isIOS) ...[
                      // buildAppleSignIn(_auth),
                      SocalCard(
                          icon: "assets/images/apple.svg",
                          press: () async {
                            final credential =
                                await SignInWithApple.getAppleIDCredential(
                              scopes: [
                                AppleIDAuthorizationScopes.email,
                                AppleIDAuthorizationScopes.fullName,
                              ],
                              webAuthenticationOptions:
                                  WebAuthenticationOptions(
                                // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                                clientId:
                                    'de.lunaone.flutter.signinwithappleexample.service',

                                redirectUri:
                                    // For web your redirect URI needs to be the host of the "current page",
                                    // while for Android you will be using the API server that redirects back into your app via a deep link
                                    kIsWeb
                                        ? Uri.parse('https://www.google.com/')
                                        : Uri.parse(
                                            'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                                          ),
                              ),
                              // TODO: Remove these if you have no need for them
                              nonce: 'example-nonce',
                              state: 'example-state',
                            );

                            // ignore: avoid_print
                            print(credential.email);
                            print(credential.givenName);
                            print(credential.familyName);
                            print(credential.identityToken);
                            print(credential.userIdentifier);
                            print(credential.authorizationCode);
                            print(credential.state);

                            FacebookLoginModel fb = FacebookLoginModel(
                                credential.email.toString(),
                                credential.givenName.toString(),
                                credential.familyName.toString(),
                                '1',
                                credential.userIdentifier.toString());
                            dynamic data = await APIService.AppleLogin(fb);

                            LoggedInUser loggedInUser =
                                LoggedInUser.fromJson(data);
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.setString(
                                "UserID", loggedInUser.data.id.toString());
                            preferences.setString(
                                "id", loggedInUser.data.id.toString());
                            preferences.setString(
                                "email", loggedInUser.data.email.toString());
                            preferences.setString("first_name",
                                loggedInUser.data.firstName.toString());
                            preferences.setString("last_name",
                                loggedInUser.data.lastName.toString());
                            preferences.setString(
                                "name", loggedInUser.data.name.toString());
                            preferences.setString("date_of_birth",
                                loggedInUser.data.dateOfBirth.toString());
                            preferences.setString(
                                "phone", loggedInUser.data.phone.toString());
                            preferences.setString(
                                "gender", loggedInUser.data.gender.toString());
                            preferences.setString("profile",
                                loggedInUser.data.profile.toString());

                            preferences.setString(
                                "loggedIntoken", loggedInUser.token.toString());
                            Navigator.pushNamed(
                                context, LoginSuccessScreen.routeName);
                            // await _auth.
                            //   if (await AppleSignIn.isAvailable()) {
                            //     final AuthorizationResult result =
                            //         await AppleSignIn.performRequests([
                            //       AppleIdRequest(requestedScopes: [
                            //         Scope.email,
                            //         Scope.fullName
                            //       ])
                            //     ]);

                            //     switch (result.status) {
                            //       case AuthorizationStatus.authorized:
                            //         print(result.status);
                            //         print(result.error.code);
                            //         print(result.credential.email);
                            //         print(result.credential.identityToken);
                            //         if (kDebugMode) {
                            //           print(result);
                            //         }
                            //         break; //All the required credentials
                            //       case AuthorizationStatus.error:
                            //         print(
                            //             "Sign in failed: ${result.error.localizedDescription}");
                            //         break;
                            //       case AuthorizationStatus.cancelled:
                            //         print('User cancelled');
                            //         break;
                            //     }
                            //     //Check if Apple SignIn isn available for the device or not
                            //     // final AuthorizationResult result =
                            //     //     await AppleSignIn.performRequests([
                            //     //   AppleIdRequest(requestedScopes: [
                            //     //     Scope.email,
                            //     //     Scope.fullName
                            //     //   ])
                            //     // ]);

                            //     // switch (result.status) {
                            //     //   case AuthorizationStatus.authorized:
                            //     //     print(result);
                            //     //     break; //All the required credentials
                            //     //   case AuthorizationStatus.error:
                            //     //     print(
                            //     //         "Sign in failed: ${result.error.localizedDescription}");
                            //     //     break;
                            //     //   case AuthorizationStatus.cancelled:
                            //     //     print('User cancelled');
                            //     //     break;
                            //     // }
                            //     // final credential =
                            //     //     await SignInWithApple.getAppleIDCredential(
                            //     //   scopes: [
                            //     //     AppleIDAuthorizationScopes.email,
                            //     //     AppleIDAuthorizationScopes.fullName,
                            //     //   ],
                            //     //   webAuthenticationOptions:
                            //     //       WebAuthenticationOptions(
                            //     //     // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                            //     //     clientId:
                            //     //         'de.lunaone.flutter.signinwithappleexample.service',

                            //     //     redirectUri:
                            //     //         // For web your redirect URI needs to be the host of the "current page",
                            //     //         // while for Android you will be using the API server that redirects back into your app via a deep link
                            //     //         kIsWeb
                            //     //             ? Uri.parse('https://www.google.com/')
                            //     //             : Uri.parse(
                            //     //                 'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                            //     //               ),
                            //     //   ),
                            //     //   // TODO: Remove these if you have no need for them
                            //     //   nonce: 'example-nonce',
                            //     //   state: 'example-state',
                            //     // );

                            //     // // ignore: avoid_print
                            //     // print(credential);

                            //     // // This is the endpoint that will convert an authorization code obtained
                            //     // // via Sign in with Apple into a session in your system
                            //     // final signInWithAppleEndpoint = Uri(
                            //     //   scheme: 'https',
                            //     //   host:
                            //     //       'flutter-sign-in-with-apple-example.glitch.me',
                            //     //   path: '/sign_in_with_apple',
                            //     //   queryParameters: <String, String>{
                            //     //     'code': credential.authorizationCode,
                            //     //     if (credential.givenName != null)
                            //     //       'firstName': credential.givenName!,
                            //     //     if (credential.familyName != null)
                            //     //       'lastName': credential.familyName!,
                            //     //     'useBundleId': !kIsWeb &&
                            //     //             (Platform.isIOS || Platform.isMacOS)
                            //     //         ? 'true'
                            //     //         : 'false',
                            //     //     if (credential.state != null)
                            //     //       'state': credential.state!,
                            //     //   },
                            //     // );

                            //     // final session = await http.Client().post(
                            //     //   signInWithAppleEndpoint,
                            //     // );

                            //     // // If we got this far, a session based on the Apple ID credential has been created in your system,
                            //     // // and you can now set this as the app's session
                            //     // // ignore: avoid_print
                            //     // print(session);

                            //     // print("clicked");
                            //     // try {
                            //     //   print("Enter try");
                            //     //   final authService = Provider.of<AuthService>(
                            //     //       context,
                            //     //       listen: false);
                            //     //   var user = await FirebaseAuthOAuth()
                            //     //       .openSignInFlow(
                            //     //           "apple.com", ["email"], {"locale": "en"});
                            //     //   print(user.displayName);
                            //     //   print('uid: ${user.uid}');
                            //     // } catch (e) {
                            //     //   // TODO: Show alert here
                            //     //   print("Exception");
                            //     //   print(e);
                            //     // }
                            //     // KeyboardUtil.hideKeyboard(context);
                            //     // Navigator.pushNamed(
                            //     //     context, LoginSuccessScreen.routeName);

                            //   } else {
                            //     print(
                            //         'Apple SignIn is not available for your device');
                            // }
                          })
                    ]
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  late UserCredential _firebaseAuth;
  Widget buildAppleSignIn(_auth) {
    if (Platform.isIOS) {
      return AppleSignInButton(
        onPressed: () async {
          await _auth.singInWithApple();

          var result = await AppleSignIn.performRequests([
            AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
          ]);

          switch (result.status) {
            case AuthorizationStatus.authorized:
              final AppleIdCredential _auth = result.credential;
              final OAuthProvider oAuthProvider = OAuthProvider("apple.com");

              final AuthCredential credential = oAuthProvider.credential(
                  idToken: String.fromCharCode(
                      int.parse(_auth.identityToken.toString())),
                  accessToken: String.fromCharCode(
                      int.parse(_auth.authorizationCode.toString())));

              print(credential);

              break;

            case AuthorizationStatus.error:
              print("Sign In Failed ${result.error.localizedDescription}");
              break;
            case AuthorizationStatus.cancelled:
              print("User Canceled");
              break;
          }
        },
      );
    } else {
      return Container();
    }
  }

  loginWithfacebook() async {
    var facebookLogin = FacebookLogin();

    var result = await facebookLogin.logIn(['email', 'public_profile']);
    FacebookAccessToken myToken = result.accessToken;

    var facebookLoginResult = await facebookLogin.logIn(
      ['email', 'public_profile'],
    );

    print(facebookLoginResult.errorMessage);
    print("Status Facebook ");
    print(facebookLoginResult.status.name);

    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken myToken = facebookLoginResult.accessToken;
      var graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=' +
              facebookLoginResult.accessToken.token));
      dynamic profile = json.decode(graphResponse.body);
      print(profile);
      String id = profile['id'];
      String first_name = profile['first_name'];
      String last_name = profile['last_name'];
      String email = profile['email'];

      FacebookLoginModel fb =
          FacebookLoginModel(email, first_name, last_name, '1', id);
      dynamic data = await APIService.FacebookLogin(fb);
      print("Iris Bag facebook");
      print(data);

      LoggedInUser loggedInUser = LoggedInUser.fromJson(data);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("UserID", loggedInUser.data.id.toString());
      preferences.setString("id", loggedInUser.data.id.toString());
      preferences.setString("email", loggedInUser.data.email.toString());
      preferences.setString(
          "first_name", loggedInUser.data.firstName.toString());
      preferences.setString("last_name", loggedInUser.data.lastName.toString());
      preferences.setString("name", loggedInUser.data.name.toString());
      preferences.setString(
          "date_of_birth", loggedInUser.data.dateOfBirth.toString());
      preferences.setString("phone", loggedInUser.data.phone.toString());
      preferences.setString("gender", loggedInUser.data.gender.toString());
      preferences.setString("profile", loggedInUser.data.profile.toString());

      preferences.setString("loggedIntoken", loggedInUser.token.toString());

      return loggedInUser;
    }
  }

  void showDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CircularProgressIndicator(),
    );
  }
}
