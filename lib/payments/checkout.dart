//Initiate the payment process

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:smartshop/models/product.dart';

class CheckoutWidget extends StatefulWidget {
  const CheckoutWidget(
      {super.key, required this.cartItems, required this.totalPrice});

  final List<Product> cartItems;
  final double totalPrice;

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm Checkout"),
      icon: const Icon(Icons.confirmation_number),
      iconColor: Colors.orangeAccent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("You are about to checkout the following items:"),
          const SizedBox(height: 10),
          for (var item in widget.cartItems)
            Text(
              "${item.name}  - \$${item.price}",
              textAlign: TextAlign.left,
            ),
          const SizedBox(height: 10),
          //display the total price to 2 decimal places
          Text("Total: \$${widget.totalPrice.toStringAsFixed(2)}"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MpesaConfirmationDialog()));
          },
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}

class MpesaConfirmationDialog extends StatelessWidget {
  const MpesaConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Mpesa Confirmation"),
      icon: const Icon(Icons.confirmation_number),
      iconColor: Colors.orangeAccent,
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Confirming the Payment will initiate a payment request to Mpesa number 2547**39***3\nEnter your Mpesa PIN to complete the transaction"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            initiateMpesaPayment();
          },
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}

Future<void> initiateMpesaPayment() async {
  // Load the smartshop.json file
  final String response = await rootBundle.loadString('smartapp.json');
  final Map<String, dynamic> data = jsonDecode(response);

  String consumerKey = data['ck'];
  String consumerSecret = data['cs'];
  String passKey = data['sec_cred'];
  MpesaFlutterPlugin.setConsumerKey(consumerKey);
  MpesaFlutterPlugin.setConsumerSecret(consumerSecret);

  print("CONSUMER KEY: $consumerKey");
  print("CONSUMER SECRET: $consumerSecret");

  Future<void> lipaNaMpesa() async {
    dynamic transactionInitialisation;
    try {
      transactionInitialisation =
          await MpesaFlutterPlugin.initializeMpesaSTKPush(
              businessShortCode: "174379",
              transactionType: TransactionType.CustomerPayBillOnline,
              amount: 1.0,
              partyA: "254795398253",
              partyB: "174379",
//Lipa na Mpesa Online ShortCode
              callBackURL: Uri(
                  scheme: "https",
                  host: "mpesa-requestbin.herokuapp.com",
                  path: "/1hhy6391"),
              accountReference: "SmartShop Payment",
              phoneNumber: "254795398253",
              baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
              transactionDesc: "Payment for $transactionInitialisation",
              passKey: passKey);
//This passkey has been generated from Test Credentials from Safaricom Portal
      print("TRANSACTION RESULT: " + transactionInitialisation.toString());
      //lets print the transaction results to console at this step
      return transactionInitialisation;
    } catch (e) {
      print("CAUGHT EXCEPTION: " + e.toString());
    }
  }

  lipaNaMpesa();
}
