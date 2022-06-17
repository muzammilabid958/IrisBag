import 'dart:async';
import 'dart:convert';

import 'package:IrisBag/constants.dart';
import 'package:IrisBag/models/SavePaymentAsGuest.dart';
import 'package:IrisBag/models/saveOrderAsGuest.dart';
import 'package:IrisBag/screens/Billing_Recipt/unpaid_page.dart';
import 'package:IrisBag/settings/settings.dart';
import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:IrisBag/constant/api_services.dart';

import 'package:IrisBag/models/Billing_Recipt.dart' as BillingReciptModel;
import 'package:IrisBag/models/SaveOrder.dart';
import 'package:IrisBag/models/payments.dart';
import 'package:IrisBag/screens/order_success/order_success_screen.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../models/widgetjson.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UnpaidPageGuest extends StatefulWidget {
  BillingReciptModel.BillingRecipt paymentdata;
  UnpaidPageGuest({Key? key, required this.paymentdata}) : super(key: key);
  @override
  _UnpaidPageGuestState createState() => _UnpaidPageGuestState(paymentdata);
}

class _UnpaidPageGuestState extends State<UnpaidPageGuest> {
  late SharedPreferences prefs;
  bool enableDisable = true;
  BillingReciptModel.BillingRecipt recipt = BillingReciptModel.BillingRecipt(
      data: BillingReciptModel.Data(
          cart: BillingReciptModel.Cart(
              id: 0,
              customerEmail: "",
              customerFirstName: "",
              customerLastName: "",
              shippingMethod: "",
              isGift: 0,
              itemsCount: 0,
              itemsQty: "",
              globalCurrencyCode: "",
              baseCurrencyCode: "",
              channelCurrencyCode: "",
              cartCurrencyCode: "",
              grandTotal: "",
              formatedGrandTotal: "",
              baseGrandTotal: "",
              formatedBaseGrandTotal: "",
              subTotal: "",
              formatedSubTotal: "",
              baseSubTotal: "",
              formatedBaseSubTotal: "",
              taxTotal: "",
              formatedTaxTotal: "",
              baseTaxTotal: "",
              formatedBaseTaxTotal: "",
              discount: "",
              formatedDiscount: "",
              baseDiscount: "",
              formatedBaseDiscount: "",
              isGuest: 0,
              isActive: 0,
              items: [],
              selectedShippingRate: BillingReciptModel.SelectedShippingRate(
                  id: 0,
                  carrier: "",
                  carrierTitle: "",
                  method: "",
                  methodTitle: "",
                  methodDescription: "",
                  price: 0,
                  formatedPrice: "",
                  basePrice: 0,
                  formatedBasePrice: "",
                  createdAt: "",
                  updatedAt: ""),
              payment: BillingReciptModel.Payment(
                  id: 0,
                  method: "",
                  methodTitle: "",
                  createdAt: "",
                  updatedAt: ""),
              billingAddress: BillingReciptModel.BillingAddress(
                  id: 0,
                  firstName: "",
                  lastName: "",
                  name: "",
                  email: "",
                  address1: [],
                  country: "",
                  countryName: "",
                  state: "",
                  city: "",
                  postcode: "",
                  phone: "",
                  createdAt: "",
                  updatedAt: ""),
              shippingAddress: BillingReciptModel.ShippingAddress(
                  id: 0,
                  firstName: "",
                  lastName: "",
                  name: "",
                  email: "",
                  address1: [],
                  country: "",
                  countryName: "",
                  state: "",
                  city: "",
                  postcode: "",
                  phone: "",
                  createdAt: "",
                  updatedAt: ""),
              createdAt: "",
              updatedAt: "",
              taxes: "",
              formatedTaxes: "",
              baseTaxes: "",
              formatedBaseTaxes: "",
              formatedDiscountedSubTotal: "",
              formatedBaseDiscountedSubTotal: ""),
          message: ""));
  late SavePaymentAsGuest savePaymentAsGuest;
  BillingReciptModel.BillingRecipt paymentdata;
  _UnpaidPageGuestState(this.paymentdata);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  late widgetjson getjson;
  readJson() async {
    // final String response =
    //     await rootBundle.loadString('assets/widgetjson.json');
    // final data = await json.decode(response);
    // setState(() {
    //   getjson = widgetjson.fromJson(data);
    // });

    final data = await APIService.jsonfile();
    getjson = widgetjson.fromJson(data);
    setState(() {
      getjson = widgetjson.fromJson(data);
    });
  }

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  bool onPressedValue = true;
  @override
  Widget build(BuildContext context) {
    var _asyncLoader = AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getMessage(),
      renderLoad: () => Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            AwesomeLoader(
              loaderType: AwesomeLoader.AwesomeLoader3,
              color: HexColor(Theme_Settings.loaderColor['color']),
            )
          ])),
      renderError: ([error]) => const Text('Something Went Wrong'),
      renderSuccess: ({data}) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.53,
          child: paymentdata.data.cart.items.length > 0
              ? FadeAnimation(
                  1.4,
                  AnimatedList(
                      scrollDirection: Axis.vertical,
                      initialItemCount: paymentdata.data.cart.items.length,
                      itemBuilder: (context, index, animation) {
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          secondaryActions: [
                            MaterialButton(
                              color: Colors.red.withOpacity(0.15),
                              elevation: 0,
                              height: 60,
                              minWidth: 60,
                              shape: CircleBorder(),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  // totalPrice = totalPrice -
                                  //     (int.parse(cartItems[index]
                                  //             .price
                                  //             .toString()) *
                                  //         cartItemCount[index]);

                                  // AnimatedList.of(context).removeItem(index,
                                  //     (context, animation) {
                                  //   return cartItem(
                                  //       cartItems[index], index, animation);
                                  // });

                                  // cartItems.removeAt(index);
                                  // cartItemCount.removeAt(index);
                                });
                              },
                            ),
                          ],
                          child: cartItem(paymentdata.data.cart.items[index],
                              index, animation),
                        );
                      }),
                )
              : Center(
                  child: Text("Empty"),
                ),
        ),
        SizedBox(height: 30),
        FadeAnimation(
          1.2,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Shipping', style: TextStyle(fontSize: 20)),
                Text(paymentdata.data.cart.formatedTaxTotal.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
        // FadeAnimation(
        //     1.3,
        //     Padding(
        //       padding: EdgeInsets.all(20.0),
        //       child: DottedBorder(
        //           color: Colors.grey.shade400,
        //           dashPattern: [10, 10],
        //           padding: EdgeInsets.all(0),
        //           child: Container()),
        //     )),
        FadeAnimation(
            1.3,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Text(paymentdata.data.cart.formatedGrandTotal.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  //'\${totalPrice + 5.99}',
                ],
              ),
            )),
        SizedBox(height: 10),
        FadeAnimation(
            1.4,
            Padding(
              padding: EdgeInsets.all(20.0),
              child: MaterialButton(
                onPressed: onPressedValue == true
                    ? () async {
                        setState(() {
                          onPressedValue = false;
                        });
                        Timer(const Duration(seconds: 30), () {
                          setState(() {
                            onPressedValue = true;
                          });
                        });
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        dynamic data = await APIService.SaveOrder(
                            preferences.getString("loggedIntoken").toString());

                        print("Unpaid Recipti");
                        print(data);
                        SaveOrderAsGuest saveOrder =
                            SaveOrderAsGuest.fromJson(data);

                        if (saveOrder.success) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderSuccessScreen(
                                      orderno: saveOrder.order.id.toString(),
                                    )),
                          );
                        }
                      }
                    : null,
                height: 50,
                elevation: 0,
                splashColor: Colors.yellow[700],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: HexColor(getjson.banner[0].primaryColor),
                child: Center(
                  child: Text(
                    "Checkout",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ))
      ]),
      // renderSuccess: ({data}) => Material(
      //     color: Colors.white,
      //     child: SafeArea(
      //       child: LayoutBuilder(
      //           builder: (_, constraints) => SingleChildScrollView(
      //               physics: const ClampingScrollPhysics(),
      //               child: ConstrainedBox(
      //                   constraints: BoxConstraints(
      //                     minHeight: constraints.maxHeight,
      //                   ),
      //                   child: Padding(
      //                       padding:
      //                           const EdgeInsets.only(top: kToolbarHeight),
      //                       child: Column(children: <Widget>[
      //                         Container(
      //                           margin: const EdgeInsets.fromLTRB(
      //                               16.0, 0, 16, 16),
      //                           padding: const EdgeInsets.fromLTRB(
      //                               16.0, 0, 16.0, 16.0),
      //                           decoration: const BoxDecoration(
      //                               color: Colors.white,
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                     color: Colors.black12,
      //                                     offset: Offset(0, 3),
      //                                     blurRadius: 6)
      //                               ],
      //                               borderRadius: BorderRadius.only(
      //                                   bottomLeft: Radius.circular(10),
      //                                   bottomRight: Radius.circular(10))),
      //                           child: Column(
      //                             mainAxisSize: MainAxisSize.min,
      //                             children: <Widget>[
      //                               for (var i = 0;
      //                                   i < recipt.data.cart.items.length;
      //                                   i++) ...[
      //                                 Container(
      //                                   margin:
      //                                       const EdgeInsets.only(top: 20),
      //                                   height: 130,
      //                                   child: Stack(
      //                                     children: <Widget>[
      //                                       Align(
      //                                         alignment:
      //                                             const Alignment(0, 0.8),
      //                                         child: Container(
      //                                             height: 200,
      //                                             margin: const EdgeInsets
      //                                                     .symmetric(
      //                                                 horizontal: 16.0),
      //                                             decoration: const BoxDecoration(
      //                                                 color: Colors.white,
      //                                                 boxShadow: [
      //                                                   BoxShadow(
      //                                                       color: Colors
      //                                                           .black12,
      //                                                       offset:
      //                                                           Offset(0, 3),
      //                                                       blurRadius: 6)
      //                                                 ],
      //                                                 borderRadius:
      //                                                     BorderRadius.only(
      //                                                         bottomLeft: Radius
      //                                                             .circular(
      //                                                                 10),
      //                                                         bottomRight: Radius
      //                                                             .circular(
      //                                                                 10))),
      //                                             child: Row(
      //                                                 mainAxisAlignment:
      //                                                     MainAxisAlignment
      //                                                         .spaceAround,
      //                                                 children: <Widget>[
      //                                                   Container(
      //                                                     padding:
      //                                                         const EdgeInsets
      //                                                                 .only(
      //                                                             top: 12.0,
      //                                                             right: 12.0,
      //                                                             left: 30),
      //                                                     width: 200,
      //                                                     child: Column(
      //                                                       crossAxisAlignment:
      //                                                           CrossAxisAlignment
      //                                                               .center,
      //                                                       children: <
      //                                                           Widget>[
      //                                                         Align(
      //                                                             alignment:
      //                                                                 Alignment
      //                                                                     .topLeft,
      //                                                             child: Container(
      //                                                                 child: Text(
      //                                                               recipt
      //                                                                   .data
      //                                                                   .cart
      //                                                                   .items[
      //                                                                       i]
      //                                                                   .name
      //                                                                   .toString(),
      //                                                               textAlign:
      //                                                                   TextAlign
      //                                                                       .left,
      //                                                               style:
      //                                                                   const TextStyle(
      //                                                                 fontWeight:
      //                                                                     FontWeight.bold,
      //                                                                 fontSize:
      //                                                                     12,
      //                                                                 color: Color(
      //                                                                     0xff202020),
      //                                                               ),
      //                                                             ))),
      //                                                         Align(
      //                                                           alignment:
      //                                                               Alignment
      //                                                                   .center,
      //                                                           child:
      //                                                               Container(
      //                                                                   width:
      //                                                                       160,
      //                                                                   padding: const EdgeInsets.only(
      //                                                                       left: 12.0,
      //                                                                       top: 8.0,
      //                                                                       bottom: 8.0),
      //                                                                   child: Text(
      //                                                                     'PKR ${recipt.data.cart.items[i].price.toString().substring(0, recipt.data.cart.items[i].price.toString().indexOf('.'))}',
      //                                                                     textAlign:
      //                                                                         TextAlign.left,
      //                                                                     style: const TextStyle(
      //                                                                         color: Color(0xff202020),
      //                                                                         fontWeight: FontWeight.bold,
      //                                                                         fontSize: 12),
      //                                                                   )),
      //                                                         ),
      //                                                         Align(
      //                                                           alignment:
      //                                                               Alignment
      //                                                                   .center,
      //                                                           child:
      //                                                               Container(
      //                                                             width: 160,
      //                                                             padding: const EdgeInsets
      //                                                                     .only(
      //                                                                 left:
      //                                                                     12.0,
      //                                                                 bottom:
      //                                                                     8.0),
      //                                                             child: Row(
      //                                                               mainAxisAlignment:
      //                                                                   MainAxisAlignment
      //                                                                       .spaceBetween,
      //                                                               children: <
      //                                                                   Widget>[
      //                                                                 Text(
      //                                                                   'Quantity ${recipt.data.cart.items[i].quantity.toString()}',
      //                                                                   textAlign:
      //                                                                       TextAlign.center,
      //                                                                   style: const TextStyle(
      //                                                                       color: Color(0xff202020),
      //                                                                       fontWeight: FontWeight.bold,
      //                                                                       fontSize: 12),
      //                                                                 )
      //                                                               ],
      //                                                             ),
      //                                                           ),
      //                                                         )
      //                                                       ],
      //                                                     ),
      //                                                   ),
      //                                                 ])),
      //                                       ),
      //                                       Container(
      //                                           child: Positioned(
      //                                               child: SizedBox(
      //                                         height: 150,
      //                                         width: 180,
      //                                         child: Stack(children: <Widget>[
      //                                           Positioned(
      //                                             left: 20,
      //                                             top: 40,
      //                                             child: SizedBox(
      //                                               height: 80,
      //                                               width: 80,
      //                                               child: CachedNetworkImage(
      //                                                 imageUrl: recipt
      //                                                     .data
      //                                                     .cart
      //                                                     .items[i]
      //                                                     .product
      //                                                     .images[0]
      //                                                     .url
      //                                                     .toString(),
      //                                                 imageBuilder: (context,
      //                                                         imageProvider) =>
      //                                                     Container(
      //                                                   decoration:
      //                                                       BoxDecoration(
      //                                                     image:
      //                                                         DecorationImage(
      //                                                       image:
      //                                                           imageProvider,
      //                                                       fit: BoxFit
      //                                                           .contain,
      //                                                     ),
      //                                                   ),
      //                                                 ),
      //                                                 progressIndicatorBuilder: (context,
      //                                                         url,
      //                                                         downloadProgress) =>
      //                                                     Center(
      //                                                         child: CircularProgressIndicator(
      //                                                             value: downloadProgress
      //                                                                 .progress)),
      //                                                 errorWidget: (context,
      //                                                         url, error) =>
      //                                                     Image.asset(
      //                                                         'assets/images/Placeholders.png'),
      //                                               ),
      //                                             ),
      //                                           ),
      //                                         ]),
      //                                       )))
      //                                     ],
      //                                   ),
      //                                 )
      //                               ],
      //                             ],
      //                           ),
      //                         ),
      //                         Container(
      //                           margin: const EdgeInsets.fromLTRB(
      //                               16.0, 0, 16, 16),
      //                           padding: const EdgeInsets.fromLTRB(
      //                               16.0, 0, 16.0, 16.0),
      //                           decoration: const BoxDecoration(
      //                               color: Colors.white,
      //                               boxShadow: [
      //                                 BoxShadow(
      //                                     color: Colors.black12,
      //                                     offset: Offset(0, 3),
      //                                     blurRadius: 6)
      //                               ],
      //                               borderRadius: BorderRadius.only(
      //                                   bottomLeft: Radius.circular(10),
      //                                   bottomRight: Radius.circular(10))),
      //                           child: Column(
      //                             mainAxisSize: MainAxisSize.min,
      //                             children: <Widget>[
      //                               ListTile(
      //                                 title: const Text('Subtotal'),
      //                                 trailing: Text(recipt.data.cart.subTotal
      //                                     .toString()
      //                                     .substring(
      //                                         0,
      //                                         recipt.data.cart.subTotal
      //                                             .indexOf('.'))),
      //                               ),
      //                               ListTile(
      //                                 title: const Text('Promo Code'),
      //                                 trailing: Text(recipt
      //                                             .data.cart.couponCode
      //                                             .toString() ==
      //                                         ""
      //                                     ? recipt.data.cart.couponCode
      //                                         .toString()
      //                                     : "N/A"),
      //                               ),
      //                               ListTile(
      //                                 title: const Text('Discount'),
      //                                 trailing: Text(recipt.data.cart.discount
      //                                     .toString()),
      //                               ),
      //                               const Divider(),
      //                               ListTile(
      //                                 title: const Text(
      //                                   'Total',
      //                                   style: TextStyle(
      //                                       fontSize: 20,
      //                                       fontWeight: FontWeight.bold),
      //                                 ),
      //                                 trailing: Text(
      //                                   "PKR " +
      //                                       recipt.data.cart.grandTotal
      //                                           .toString()
      //                                           .substring(
      //                                               0,
      //                                               recipt
      //                                                   .data.cart.grandTotal
      //                                                   .indexOf('.')),
      //                                   style: const TextStyle(
      //                                       fontSize: 20,
      //                                       fontWeight: FontWeight.bold),
      //                                 ),
      //                               )
      //                             ],
      //                           ),
      //                         ),
      //                         const SizedBox(
      //                           height: 24,
      //                         ),
      //                         Padding(
      //                           padding: const EdgeInsets.only(bottom: 20),
      //                           // child: payNow,
      //                           child: InkWell(
      //                               child: RaisedButton(
      //                             color: HexColor(
      //                                 getjson.banner[0].primaryColor),
      //                             onPressed: onPressedValue == true
      //                                 ? () async {
      //                                     setState(() {
      //                                       onPressedValue = false;
      //                                     });
      //                                     Timer(const Duration(seconds: 30),
      //                                         () {
      //                                       setState(() {
      //                                         onPressedValue = true;
      //                                       });
      //                                     });
      //                                     SharedPreferences preferences =
      //                                         await SharedPreferences
      //                                             .getInstance();
      //                                     dynamic data = await APIService
      //                                         .SaveOrder(preferences
      //                                             .getString("loggedIntoken")
      //                                             .toString());

      //                                     print("Unpaid Recipti");
      //                                     print(data);
      //                                     SaveOrder saveOrder =
      //                                         SaveOrder.fromJson(data);

      //                                     if (saveOrder.success) {
      //                                       Navigator.push(
      //                                         context,
      //                                         MaterialPageRoute(
      //                                             builder: (context) =>
      //                                                 OrderSuccessScreen(
      //                                                   orderno: saveOrder
      //                                                       .order.id
      //                                                       .toString(),
      //                                                 )),
      //                                       );
      //                                     }
      //                                   }
      //                                 : null,
      //                             shape: RoundedRectangleBorder(
      //                                 borderRadius:
      //                                     BorderRadius.circular(80.0)),
      //                             padding: const EdgeInsets.all(0.0),
      //                             child: Ink(
      //                               child: Container(
      //                                 color: HexColor(
      //                                     getjson.banner[0].primaryColor),
      //                                 height: 70,
      //                                 width: 300,
      //                                 alignment: Alignment.center,
      //                                 child: const Text("Pay Now",
      //                                     style: TextStyle(
      //                                         color: Color(0xfffefefe),
      //                                         fontWeight: FontWeight.w600,
      //                                         fontStyle: FontStyle.normal,
      //                                         fontSize: 20.0)),
      //                               ),
      //                             ),
      //                           )),
      //                         )
      //                       ]))))),
      //     ))
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Confirm Order",
          ),
        ),
        body: _asyncLoader);
  }

  static const TIMEOUT = const Duration(seconds: 5);

  getMessage() async {
    return new Future.delayed(TIMEOUT, () => {});
  }
}
