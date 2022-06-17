import 'package:flutter/material.dart';

import 'components/bodyShipmentFormGuest.dart';

class ShipmentFormGuestUser extends StatefulWidget {
  static String routeName = "/shipment";

  @override
  State<ShipmentFormGuestUser> createState() => _ShipmentFormGuestUserState();
}

class _ShipmentFormGuestUserState extends State<ShipmentFormGuestUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Address'),
        actions: [],
      ),
      body: ShipmentFormGuestBody(),
    );
  }
}
