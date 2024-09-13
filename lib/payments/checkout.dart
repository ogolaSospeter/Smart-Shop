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
      {super.key,
      required this.cartItems,
      required this.totalPrice,
      required this.itemQuantities});

  final List<Product> cartItems;
  final double totalPrice;
  final Map<int, int> itemQuantities;
  final DatabaseHelper databaseHelper = DatabaseHelper();

  //get the user data for the logged in user
  Future<User?> _getUserData() async {
    return await databaseHelper.getLoggedInUser();
  }

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  var orderItems = <Order>[];
  var synchronizedCartItems = <Order>[];
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.cartItems.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                var quantity = widget.itemQuantities[item.id] ?? 1;
                print("The itemQuantities: ${widget.itemQuantities}");

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
                        "\$${item.price * quantity}",
                        textAlign:
                            TextAlign.left, // Aligns the price to the right
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Expanded(
                      flex: 1, // Adjust to give space to the price
                      child: Text(
                        "Qty: ${quantity.toString()}",
                        textAlign:
                            TextAlign.right, // Aligns the price to the right
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
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
            Navigator.pop(context);
            // Fetch the user data asynchronously
            var snapshot = await widget._getUserData();
            if (snapshot != null) {
              // Create order items once user data is available
              // var orderItems = <Order>[];
              var user = snapshot.email; // Assuming user has an email field
              var currentDate = DateTime.now();
              //convert the current date to yyyy-mm-dd format
              var formattedDate =
                  "${currentDate.year}-${currentDate.month}-${currentDate.day}";
              for (int i = 0; i < widget.cartItems.length; i++) {
                //format the total price to 2 decimal places
                final price =
                    double.parse(widget.totalPrice.toStringAsFixed(2));
                var orderItem = Order(
                  orderId: currentDate.millisecondsSinceEpoch,
                  orderDate: formattedDate,
                  orderStatus: "Pending",
                  orderTotal: price,
                  itemId: widget.cartItems[i].id,
                  custId: user,
                  quantity: widget.itemQuantities[widget.cartItems[i].id]!,
                );
                orderItems.add(orderItem);
              }

              // Show a success dialog
              var existingOrdersList = <Order>[];
              final Future<List<Order>> existingOrders =
                  databaseHelper.getOrdersByUser(orderItems[0].custId);
              existingOrders.then(
                (value) {
                  existingOrdersList = value;
                },
              ).whenComplete(() {
                //check if the item in the cart is in the existing orders list
                var matchedList = <Order>[];
                for (var item in orderItems) {
                  for (var order in existingOrdersList) {
                    if (item.itemId == order.itemId &&
                        item.custId == order.custId &&
                        item.orderDate == order.orderDate) {
                      matchedList.add(order);
                    }
                  }
                  synchronizedCartItems.add(item);
                }

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    //add the items shopped to the Orders table
                    print(
                        "\nThe existing orders in the Order table:   $existingOrdersList\n");
                    print("\nThe existing orders are: $matchedList\n");

                    print(
                        "\nAdding Non-exixting items to the Orders table.\n The items are: $synchronizedCartItems");
                    for (Order item in orderItems) {
                      try {
                        if (existingOrdersList.isEmpty) {
                          databaseHelper
                              .getProductQuantity(item.itemId)
                              .then((value) {
                            if (value > 5) {
                              var newQuantity = value - item.quantity;
                              databaseHelper.updateProductQuantity(
                                  item.itemId, newQuantity);
                              //add the item to the Orders table
                              databaseHelper.insertOrder(item);
                              print(
                                  "Synchronized orders list at normal non-existing order $synchronizedCartItems");
                              print(
                                  "The item ${item.itemId} has been added successfully to the Orders table.");
                              //remove the item from the cart
                              databaseHelper.deleteProductFromCart(item.itemId);
                            } else {
                              //show snackbar if the item is out of stock
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "The item ${item.itemId} is out of stock."),
                                ),
                              );
                            }
                          });
                        }
                      } catch (e) {
                        print("Error adding item to the Orders table: $e");
                      }
                    }
                    if (matchedList.isNotEmpty) {
                      //Alert the user and display the items that have already been ordered. Confirm if the user wants to proceed with the making the order, then add the items to the Orders table
                      return AlertDialog(
                        title: const Text("Confirm Re-order of Items"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                                "The following items have already been ordered:"),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: matchedList.asMap().entries.map(
                                  (entry) {
                                    int index = entry.key;
                                    var item = entry.value;
                                    var quantity = item.quantity;
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // Centers the Row content
                                      children: [
                                        // Item index
                                        Text(
                                          "${index + 1}.",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                            width:
                                                10), // Spacing between index and name

                                        // Item name (takes some space but leaves room for price)
                                        Expanded(
                                          flex:
                                              2, // Adjust to give more space to the name
                                          child: Text(
                                            item.itemId.toString(),
                                            textAlign: TextAlign
                                                .start, // Centers the name
                                            overflow: TextOverflow
                                                .ellipsis, // Truncate name if too long
                                          ),
                                        ),

                                        const SizedBox(
                                            width:
                                                20), // Space between name and price

                                        // Item price (takes fixed space)
                                        Expanded(
                                          flex:
                                              1, // Adjust to give space to the price
                                          child: Text(
                                            "\$${item.orderTotal}",
                                            textAlign: TextAlign
                                                .left, // Aligns the price to the right
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Expanded(
                                          flex:
                                              1, // Adjust to give space to the price
                                          child: Text(
                                            "Qty: ${quantity.toString()}",
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                                "Do you want to proceed with the order?"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text("Close"),
                          ),
                          TextButton(
                            onPressed: () {
                              //add the items to the Orders table
                              for (Order item in existingOrdersList) {
                                try {
                                  databaseHelper
                                      .getProductQuantity(item.itemId)
                                      .then((value) {
                                    if (value > 5) {
                                      var newQuantity = value - item.quantity;
                                      databaseHelper.updateProductQuantity(
                                          item.itemId, newQuantity);
                                      //add the item to the Orders table
                                      databaseHelper.insertOrder(item);
                                      print(
                                          "The synchronized orders list before adding the reordered item:\n $synchronizedCartItems");
                                      synchronizedCartItems.add(item);
                                      print(
                                          "Synchronized list after adding reordered item: $synchronizedCartItems");
                                      //remove the item from the cart
                                      databaseHelper
                                          .deleteProductFromCart(item.itemId);
                                    } else {
                                      //show snackbar if the item is out of stock
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "The item ${item.itemId} is out of stock."),
                                        ),
                                      );
                                    }
                                  });
                                } catch (e) {
                                  print(
                                      "Error adding re-ordered item to the Orders table: $e");
                                }
                              }
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text("Confirm"),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                );
              });

              //get the phone number of the user from a pop up dialog then navigate to the MpesaConfirmationDialog
              Future.delayed(const Duration(seconds: 3));
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
                          Navigator.popAndPushNamed(context, '/checkout');
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MpesaConfirmationDialog(
                                cartItems: synchronizedCartItems,
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
    print(
        "The received Synchronized list in the MpesaConfirmationDialogue: \n$cartItems \n");
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
                      text:
                          " Kshs. ${(totalPrice * 129.00).toStringAsFixed(2)} ",
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
              Navigator.popAndPushNamed(context, '/checkout');
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
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
                  Future.delayed(
                    Duration(seconds: 3),
                    () {
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
                                  Navigator.popAndPushNamed(context,
                                      '/checkout'); // Close the error dialog
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Payment Success."),
                        content: const Text(
                            "Your payment was initiated successfully. Please wait for the payment prompt and enter M-Pesa PIN."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                  context); // Close the success dialog
                              //reload the page to show the updated cart
                              Navigator.popAndPushNamed(context, '/checkout');
                            },
                            child: const Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            },
            child: const Text("Confirm"),
          )
        ]);
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
      accountReference: "SMARTSHOP PRODUCTS JAMAGUJE",
      // accountReference: "SmartShop Payment",
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
              accountReference: "JUJA GREETINGS ~~The JOHNS😎😍",
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
