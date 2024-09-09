//Initiate the payment process

import 'package:flutter/material.dart';
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
    return SizedBox(
      height: 200,
      child: AlertDialog(
        title: const Text("Confirm Checkout"),
        icon: const Icon(Icons.confirmation_number),
        iconColor: Colors.orangeAccent,
        content: Column(
          children: [
            const Text("You are about to checkout the following items:"),
            const SizedBox(height: 10),
            for (var item in widget.cartItems)
              Text("${item.name}  - \$${item.price}"),
            const SizedBox(height: 10),
            Text("Total: \$${widget.totalPrice.roundToDouble()}"),
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
              MpesaConfirmationDialog(context);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}

Widget MpesaConfirmationDialog(BuildContext context) {
  return AlertDialog(
    title: const Text("Mpesa Confirmation"),
    icon: const Icon(Icons.confirmation_number),
    iconColor: Colors.orangeAccent,
    content: const Column(
      children: [
        Text("You are about to checkout using Mpesa."),
        SizedBox(height: 10),
        Text("Please confirm the payment on your phone."),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Confirm"),
      ),
    ],
  );
}
