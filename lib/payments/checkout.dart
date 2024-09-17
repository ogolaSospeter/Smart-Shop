import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'package:smartshop/database/firestore_database.dart';
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
  final Map<String, int> itemQuantities;
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();

  //get the user data for the logged in user
  Future<User?> _getUserData() async {
    return await databaseHelper.getLoggedInUser();
  }

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();
  var orderItems = <Orders>[];
  var synchronizedCartItems = <Orders>[]; // Final cart items after checks
  final TextEditingController _controllerPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm Checkout"),
      icon: const Icon(CupertinoIcons.check_mark_circled,
          color: Colors.deepPurple, size: 40),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("You are about to checkout the following items:"),
          const SizedBox(height: 4),
          _buildCartItems(), // Build the cart items list view
          const Divider(thickness: 2),
          Text("Total: \$${widget.totalPrice.toStringAsFixed(2)}",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(thickness: 2),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _handleCheckout,
          child: const Text("Proceed"),
        ),
      ],
    );
  }

  // Build method for cart items
  Widget _buildCartItems() {
    return Column(
      children: widget.cartItems.asMap().entries.map((entry) {
        int index = entry.key;
        var item = entry.value;
        var quantity = widget.itemQuantities[item.id] ?? 1;

        return Row(
          children: [
            Text("${index + 1}.",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              flex: 2,
              child: Text(item.name, overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              child: Text("\$${(item.price * quantity).toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            Expanded(
              child: Text("Qty: $quantity"),
            ),
          ],
        );
      }).toList(),
    );
  }

  // Handle the checkout flow
  Future<void> _handleCheckout() async {
    var snapshot = await widget._getUserData();
    if (snapshot != null) {
      var user = snapshot.email;
      var formattedDate =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

      // Prepare order items
      for (var item in widget.cartItems) {
        var price = item.price * widget.itemQuantities[item.id]!;
        orderItems.add(Orders(
          orderId: DateTime.now().millisecondsSinceEpoch,
          orderDate: formattedDate,
          orderPhone: '',
          orderTotal: double.parse(price.toStringAsFixed(2)),
          orderStatus: "Ordered",
          itemId: item.id,
          custId: user,
          quantity: widget.itemQuantities[item.id]!,
        ));
      }

      // Fetch existing orders for the user
      var existingOrdersList = await databaseHelper.getOrdersByUser(user);
      var matchedList = _getMatchedOrders(existingOrdersList);

      if (matchedList.isNotEmpty) {
        //add the unmatched items to the synchronizedCartItems
        for (var item in orderItems) {
          if (!matchedList.contains(item)) {
            synchronizedCartItems.add(item);
          }
        }
        // Alert for re-order confirmation
        _showReOrderDialog(matchedList);
      } else {
        synchronizedCartItems.addAll(orderItems);
        Navigator.pop(context);
        // Proceed with payment initiation (No previous orders matched)
        _initiatePayment();
      }
    }
  }

  // Get matched orders based on date and user
  List<Orders> _getMatchedOrders(List<Orders> existingOrders) {
    return orderItems.where((item) {
      return existingOrders.any((order) =>
          order.itemId == item.itemId && order.orderDate == item.orderDate);
    }).toList();
  }

  // Show dialog for re-order confirmation
  void _showReOrderDialog(List<Orders> matchedList) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Re-order Confirmation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("The items below were ordered earlier today:"),
              ...matchedList.map((order) {
                var index = matchedList.indexOf(order) + 1;
                return ListTile(
                  title: const Expanded(
                      child: Text("Index\t\t ItemId \t\t Total")),
                  subtitle: Text(
                      "$index. \t\t${order.itemId} \t\t\$${order.orderTotal}"),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Update synchronizedCartItems with matched items and proceed
                synchronizedCartItems.addAll(matchedList);
                Navigator.pop(context);
                _initiatePayment(); // Proceed to payment after confirmation
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  // Method to initiate the payment process
  void _initiatePayment() {
    var phone = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Enter your phone number to proceed.\nUse format 2547XXXXXXXX",
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          content: TextField(
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.center,
            onChanged: (value) {
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
                var message = '';
                if (phone.substring(0, 3) != "254" ||
                    phone.length < 12 ||
                    phone.length > 12) {
                  if (phone.substring(0, 3) != "254") {
                    message = "Use the Correct format of 2547XXXXXXXX";
                  }
                  if (phone.length < 12 || phone.length > 12) {
                    message =
                        "The Phone Number must be 12 characters in length Only!";
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                  _initiatePayment();
                } else {
                  _launchMpesaCheckout(phone, context);
                }
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  // Mockup method for launching Mpesa Checkout
  void _launchMpesaCheckout(String phoneNumber, BuildContext context) {
    // Trigger Mpesa payment with synchronizedCartItems
    final totalPrice = widget.totalPrice;
    // Ensure you are calling this function at the right point
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MpesaConfirmationDialog(
          cartItems: synchronizedCartItems, // Pass the updated cart items
          totalPrice: totalPrice, // Pass the total price
          phone: phoneNumber, // Pass the phone number
        );
      },
    );

    //   MpesaConfirmationDialog(
    //       cartItems: synchronizedCartItems,
    //       totalPrice: totalPrice,
    //       phone: phoneNumber);
  }
}

class MpesaConfirmationDialog extends StatelessWidget {
  MpesaConfirmationDialog(
      {super.key,
      required this.cartItems,
      required this.totalPrice,
      required this.phone});
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();

  final List<Orders> cartItems;
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

              MpesaPaymentGateWay(totalPrice, phone)
                  .then((transactionInitialisation) {
                // Close the loading dialog
                Navigator.popAndPushNamed(context, '/checkout');

                // Check if there's an error in the response
                if (transactionInitialisation.containsKey("errorCode")) {
                  // Show a failure dialog
                  Future.delayed(
                    const Duration(seconds: 3),
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
                              //delete the items from the cart
                              for (Orders item in cartItems) {
                                item.orderPhone = phone;
                                try {
                                  databaseHelper
                                      .getProductStockLevel(item.itemId)
                                      .then((stockLevel) {
                                    if (stockLevel > 5 &&
                                        item.quantity <= (stockLevel)) {
                                      var newQuantity =
                                          stockLevel - item.quantity;
                                      databaseHelper.updateProductStockLevel(
                                          item.itemId, newQuantity);
                                    } else {
                                      databaseHelper.updateOrderStatus(
                                          item.orderId, "Out of Stock");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "The item ${item.itemId} is currently out of stock. We will notify you once it is stocked."),
                                          duration: const Duration(seconds: 2),
                                          elevation: 9,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          animation: CurvedAnimation(
                                            parent:
                                                const AlwaysStoppedAnimation(
                                                    1.0),
                                            curve: Curves.easeInOutBack,
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                } catch (e) {
                                  print(
                                      "Error adding re-ordered item to the Orders table: $e");
                                }
                                databaseHelper.insertOrder(item);
                                //update the stock level

                                databaseHelper.deleteProductFromCart(
                                    item.itemId.toString());
                              }
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
        '${phone.substring(0, 6)}****${phone.substring(phone.length - 2)}'; // show the last 2 characters (e.g., '43')
    return maskedPhone;
  } else {
    return phone; // If the phone number is too short, return it unmasked
  }
}
