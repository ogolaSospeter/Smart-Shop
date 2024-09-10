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
              //get the phone number of the user from a pop up dialog then navigate to the MpesaConfirmationDialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  var phone = "";
                  return AlertDialog(
                    title: const Text(
                      "Enter your phone number to proceed\nUse the format 2547XXXXXXXX",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        //get the phone number from the text field
                        phone = value;
                      },
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
                              builder: (context) => MpesaConfirmationDialog(
                                cartItems: orderItems,
                                totalPrice: widget.totalPrice,
                                phone: phone,
                              ),
                            ),
                          );
                        },
                        child: const Text("Confirm"),
                      ),
                    ],
                  );
                },
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
      ],
    );
  }
}

class MpesaConfirmationDialog extends StatelessWidget {
  MpesaConfirmationDialog(
      {super.key,
      required this.cartItems,
      required this.totalPrice,
      required this.phone});
  final DatabaseHelper databaseHelper = DatabaseHelper();

  final List<Order> cartItems;
  final double totalPrice;
  final String phone;

  @override
  Widget build(BuildContext context) {
    var maskedPhone = maskPhoneNumber(phone);
    return AlertDialog(
      title: const Text("Mpesa Confirmation"),
      icon: const Icon(Icons.question_answer_rounded),
      iconColor: Colors.deepPurple,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
                children: [
                  const TextSpan(
                    text:
                        "Confirming the Payment will initiate a payment request of ",
                  ),
                  TextSpan(
                    text: " Kshs. ${(totalPrice * 129.00).toStringAsFixed(2)} ",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: " to the number $maskedPhone",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/checkout');
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
            var totalPrice = (this.totalPrice * 129.00).toStringAsFixed(0);
            print("Total Price sent to the gateway: $totalPrice");
            print("Phone number sent to the gateway: $phone");
            MpesaPaymentGateWay(totalPrice, phone)
                .then((transactionInitialisation) {
              // Close the loading dialog
              Navigator.popAndPushNamed(context, '/checkout');

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
                    print(
                        "Adding items to the Orders table.\n The items are: $cartItems");
                    for (Order item in cartItems) {
                      databaseHelper.insertOrder(item);
                    }
                    return AlertDialog(
                      title: const Text("Payment Success."),
                      content: const Text(
                          "Your payment was initiated successfully. Please wait for the payment prompt and enter M-Pesa PIN."),
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
                          Navigator.popAndPushNamed(
                              context, '/checkout'); // Close the error dialog
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
      ],
    );
  }
}

Future<Map<String, dynamic>> MpesaPaymentGateWay(amount, phone) async {
  final String response = await rootBundle.loadString('smartapp.json');
  final Map<String, dynamic> data = jsonDecode(response);

  String consumerKey = data['ckey'];
  String consumerSecret = data['cst'];
  String passKey = data['sec_cred'];

  MpesaFlutterPlugin.setConsumerKey(consumerKey);
  MpesaFlutterPlugin.setConsumerSecret(consumerSecret);

  try {
    // Initialize the Mpesa STK Push
    var transactionInitialisation =
        await MpesaFlutterPlugin.initializeMpesaSTKPush(
      businessShortCode: "174379",
      transactionType: TransactionType.CustomerPayBillOnline,
      amount: double.parse(amount),
      partyA: phone,
      partyB: "174379",
      callBackURL: Uri.parse("https://sandbox.safaricom.co.ke/"),
      accountReference: "SmartShop Payment",
      phoneNumber: phone,
      transactionDesc: "Purchase",
      baseUri: Uri.parse("https://sandbox.safaricom.co.ke/"),
      passKey: passKey,
    );

    print("Transaction Result: $transactionInitialisation");

    return transactionInitialisation; // Return the map of the result
  } catch (e) {
    print("Exception: $e");
    return {"errorMessage": e.toString()};
  }
}

String maskPhoneNumber(String phone) {
  // Check if the phone number has the correct length before masking
  if (phone.length >= 10) {
    // Mask the phone number: show the first 6 characters, mask the next 4, and show the last 2 characters
    var maskedPhone =
        phone.substring(0, 6) + // first 6 characters (e.g., '254732')
            '****' + // mask the next 4 characters
            phone.substring(
                phone.length - 2); // show the last 2 characters (e.g., '43')
    return maskedPhone;
  } else {
    return phone; // If the phone number is too short, return it unmasked
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
