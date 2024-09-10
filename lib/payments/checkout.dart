//Initiate the payment process

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:smartshop/database/database_operations.dart';
import 'package:smartshop/models/orders.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/models/user.dart';

class CheckoutWidget extends StatefulWidget {
  CheckoutWidget(
      {super.key, required this.cartItems, required this.totalPrice});

  final List<Product> cartItems;
  final double totalPrice;
  final DatabaseHelper dbHelper = DatabaseHelper();

  //get the user data for the logged in user
  Future<User?> _getUserData() async {
    return await dbHelper.getLoggedInUser();
  }

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm Checkout"),
      icon: const Icon(
        CupertinoIcons.check_mark_circled,
        color: Colors.deepPurple,
        size: 40,
      ),
      iconColor: Colors.orangeAccent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("You are about to checkout the following items:"),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.cartItems.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;

                return Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centers the Row content
                  children: [
                    // Item index
                    Text(
                      "${index + 1}.",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10), // Spacing between index and name

                    // Item name (takes some space but leaves room for price)
                    Expanded(
                      flex: 2, // Adjust to give more space to the name
                      child: Text(
                        item.name,
                        textAlign: TextAlign.start, // Centers the name
                        overflow:
                            TextOverflow.ellipsis, // Truncate name if too long
                      ),
                    ),

                    const SizedBox(width: 20), // Space between name and price

                    // Item price (takes fixed space)
                    Expanded(
                      flex: 1, // Adjust to give space to the price
                      child: Text(
                        "\$${item.price}",
                        textAlign:
                            TextAlign.left, // Aligns the price to the right
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),
          //display the total price to 2 decimal places
          //display a line break
          const Divider(
            color: Colors.black,
            height: 4,
            indent: 25,
            endIndent: 25,
            thickness: 2,
          ),
          const SizedBox(height: 5),
          Text(
            "Total: \t\$${widget.totalPrice.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          const Divider(
            color: Colors.black,
            height: 4,
            indent: 25,
            endIndent: 25,
            thickness: 2,
          ),
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
          onPressed: () async {
            // Fetch the user data asynchronously
            var snapshot = await widget._getUserData();
            if (snapshot != null) {
              // Create order items once user data is available
              var orderItems = <Order>[];
              var user = snapshot.email; // Assuming user has an email field
              var currentDate = DateTime.now();
              for (Product item in widget.cartItems) {
                var orderItem = Order(
                  orderId: currentDate.millisecondsSinceEpoch,
                  orderDate: currentDate.toString(),
                  orderStatus: "Pending",
                  orderTotal: widget.totalPrice,
                  itemId: item.id,
                  custId: user,
                  quantity: item.quantity,
                );
                orderItems.add(orderItem);
              }
              // Navigate to the MpesaConfirmationDialog with the order items
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MpesaConfirmationDialog(
                    cartItems: orderItems, // Pass the orderItems as List<Order>
                  ),
                ),
              );
            } else {
              // Show error if user data could not be fetched
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Error fetching user data"),
                ),
              );
            }
          },
          child: const Text("Confirm"),
        ),

        // TextButton(
        //   onPressed: () {
        //     FutureBuilder<User?>(
        //       future: widget._getUserData(),
        //       builder: (context, snapshot) {
        //         var orderItems = [];
        //         if (snapshot.hasData) {
        //           for (Product item in widget.cartItems) {
        //             var user = snapshot.data!.email;
        //             var current_date = DateTime.now();
        //             var orderItem = Order(
        //               orderId: current_date.millisecondsSinceEpoch,
        //               orderDate: current_date.toString(),
        //               orderStatus: "Pending",
        //               orderTotal: widget.totalPrice,
        //               itemId: item.id,
        //               custId: user,
        //               quantity: item.quantity,
        //             );
        //             orderItems.add(orderItem);
        //           }
        //           Navigator.pushReplacement(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => MpesaConfirmationDialog(
        //                 cartItems: orderItems as List<Order>,
        //               ),
        //             ),
        //           );
        //         } else {
        //           return const Text("Error fetching user data");
        //         }
        //       },
        //     );
        //   },
        //   child: const Text("Confirm"),
        // ),
      ],
    );
  }
}

class MpesaConfirmationDialog extends StatelessWidget {
  MpesaConfirmationDialog({super.key, required this.cartItems});
  final DatabaseHelper databaseHelper = DatabaseHelper();

  final List<Order> cartItems;

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
                "Confirming the Payment will initiate a payment request to Mpesa number 2547**39***3"),
            const SizedBox(height: 2),
            Text("Enter your Mpesa PIN on the prompt that will appear.",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
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
            // Show the loading dialog while the payment is being processed
            showDialog(
              context: context,
              barrierDismissible:
                  false, // Prevents dismissing the dialog by tapping outside
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Processing Payment......"),
                  content: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 10.0,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        minHeight: 10.0,
                      ),
                    ),
                  ),
                );
              },
            );

            // Initiate the payment process and handle the result
            MpesaPaymentGateWay().then((transactionInitialisation) {
              // Close the loading dialog
              Navigator.pop(context);

              // Check if there's an error in the response
              if (transactionInitialisation.containsKey("errorCode")) {
                // Show a failure dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Payment Failed"),
                      content: Text(
                          "There was an error processing your payment: ${transactionInitialisation["errorMessage"] ?? "Unknown error"}"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context, '/checkout'); // Close the error dialog
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              } else {
                // Show a success dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    //add the items shopped to the Orders table
                    for (Order item in cartItems) {
                      databaseHelper.insertOrder(item);
                    }
                    return AlertDialog(
                      title: const Text("Payment Successful"),
                      content: const Text(
                          "Your payment was successful. You will receive a confirmation message shortly."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the success dialog
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              }
            }).catchError((error) {
              // Close the loading dialog if an error occurs
              Navigator.pop(context);

              // Show an error dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Payment Failed"),
                    content: Text(
                        "There was an error processing your payment: $error"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the error dialog
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  );
                },
              );
            });
          },
          child: const Text("Confirm"),
        )

        // TextButton(
        //   onPressed: () {
        //     // Show the loading dialog while the payment is being processed
        //     showDialog(
        //       context: context,
        //       barrierDismissible:
        //           false, // Prevents dismissing the dialog by tapping outside
        //       builder: (BuildContext context) {
        //         return const AlertDialog(
        //           title: Text("Processing Payment"),
        //           content: Padding(
        //             padding: EdgeInsets.all(10.0),
        //             child: CircularProgressIndicator(),
        //           ),
        //         );
        //       },
        //     );

        //     // Initiate the payment process and handle the result
        //     MpesaPaymentGateWay().then((transactionInitialisation) {
        //       // Close the loading dialog
        //       Navigator.pop(context);

        //       // Show a success dialog if payment was successful
        //       showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           if (transactionInitialisation.toString() == "Success") {
        //             return AlertDialog(
        //               title: const Text("Payment Successful"),
        //               content: const Text(
        //                   "Your payment was successful. You will receive a confirmation message shortly."),
        //               actions: [
        //                 TextButton(
        //                   onPressed: () {
        //                     Navigator.pop(context); // Close the success dialog
        //                   },
        //                   child: const Text("Close"),
        //                 ),
        //               ],
        //             );
        //           } else {
        //             return AlertDialog(
        //               title: const Text("Payment Failed"),
        //               content: const Text(
        //                   "There was an error processing your payment. Please try again."),
        //               actions: [
        //                 TextButton(
        //                   onPressed: () {
        //                     Navigator.pop(context); // Close the error dialog
        //                   },
        //                   child: const Text("Close"),
        //                 ),
        //               ],
        //             );
        //           }
        //         },
        //       );
        //     }).catchError((error) {
        //       // Close the loading dialog if an error occurs
        //       Navigator.pop(context);

        //       // Show an error dialog
        //       showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //             title: const Text("Payment Failed"),
        //             content: Text(
        //                 "There was an error processing your payment: $error"),
        //             actions: [
        //               TextButton(
        //                 onPressed: () {
        //                   Navigator.pop(context); // Close the error dialog
        //                 },
        //                 child: const Text("Close"),
        //               ),
        //             ],
        //           );
        //         },
        //       );
        //     });
        //   },
        //   child: const Text("Confirm"),
        // ),
      ],
    );
  }
}

Future<Map<String, dynamic>> MpesaPaymentGateWay() async {
  MpesaFlutterPlugin.setConsumerKey(
      "xRdARio3AIzxlE9sPFVoSi48bT09MdyAGOy7l2Yl92WaWCJR");
  MpesaFlutterPlugin.setConsumerSecret(
      "nziM9tZ3lRxDmclIRFOENXN2IJlwgBIPHRyqbKJNO0b7TkkvjK4nXrs7sdX5NYwd");

  try {
    // Initialize the Mpesa STK Push
    var transactionInitialisation =
        await MpesaFlutterPlugin.initializeMpesaSTKPush(
      businessShortCode: "174379",
      transactionType: TransactionType.CustomerPayBillOnline,
      amount: double.parse("1"),
      partyA: "254795398253",
      partyB: "174379",
      callBackURL: Uri.parse("https://sandbox.safaricom.co.ke/"),
      accountReference: "Flutter Mpesa Tutorial",
      phoneNumber: "254795398253",
      transactionDesc: "Purchase",
      baseUri: Uri.parse("https://sandbox.safaricom.co.ke/"),
      passKey: "xRdARio3AIzxlE9sPFVoSi48bT09MdyAGOy7l2Yl92WaWCJR",
    );

    print("Transaction Result: $transactionInitialisation");

    return transactionInitialisation; // Return the map of the result
  } catch (e) {
    print("Exception: $e");
    return {"errorMessage": e.toString()};
  }
}

Future<void> initiateMpesaPayment() async {
  // Load the smartshop.json file
  final String response = await rootBundle.loadString('smartapp.json');
  final Map<String, dynamic> data = jsonDecode(response);

  String consumerKey = data['ckey'];
  String consumerSecret = data['cst'];
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
//Lipa na Mpesa Online ShortCode`
              callBackURL: Uri(
                  scheme: "https",
                  host: "mpesa-requestbin.herokuapp.com",
                  path: "/1hhy6391"),
              accountReference: "SmartShop Payment",
              phoneNumber: "254795398253",
              baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
              transactionDesc: "Payment for $transactionInitialisation",
              passKey: passKey);
      print("TRANSACTION RESULT: " + transactionInitialisation.toString());
      //lets print the transaction results to console at this step
      return transactionInitialisation;
    } catch (e) {
      print("CAUGHT EXCEPTION: " + e.toString());
    }
  }

  lipaNaMpesa();
}
