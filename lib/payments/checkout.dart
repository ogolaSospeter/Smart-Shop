//Initiate the payment process

// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

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
  final Map<int, int> itemQuantities;
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();

  //get the user data for the logged in user
  Future<User?> _getUserData() async {
    return await databaseHelper.getLoggedInUser();
  }

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

// class _CheckoutWidgetState extends State<CheckoutWidget> {
//   final DatabaseHelper databaseHelper = DatabaseHelper();
//   var orderItems = <Orders>[];
//   var synchronizedCartItems = <Orders>[];
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Confirm Checkout"),
//       icon: const Icon(
//         CupertinoIcons.check_mark_circled,
//         color: Colors.deepPurple,
//         size: 40,
//       ),
//       iconColor: Colors.orangeAccent,
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text("You are about to checkout the following items:"),
//           const SizedBox(height: 4),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: widget.cartItems.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 var item = entry.value;
//                 var quantity = widget.itemQuantities[item.id] ?? 1;

//                 return Row(
//                   mainAxisAlignment:
//                       MainAxisAlignment.center, // Centers the Row content
//                   children: [
//                     // Item index
//                     Text(
//                       "${index + 1}.",
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(width: 10), // Spacing between index and name

//                     // Item name (takes some space but leaves room for price)
//                     Expanded(
//                       flex: 2, // Adjust to give more space to the name
//                       child: Text(
//                         item.name,
//                         textAlign: TextAlign.start, // Centers the name
//                         overflow:
//                             TextOverflow.ellipsis, // Truncate name if too long
//                       ),
//                     ),

//                     const SizedBox(width: 20), // Space between name and price

//                     // Item price (takes fixed space)
//                     Expanded(
//                       flex: 1, // Adjust to give space to the price
//                       child: Text(
//                         "\$${item.price * quantity}",
//                         textAlign:
//                             TextAlign.left, // Aligns the price to the right
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 2,
//                     ),
//                     Expanded(
//                       flex: 1, // Adjust to give space to the price
//                       child: Text(
//                         "Qty: ${quantity.toString()}",
//                         textAlign:
//                             TextAlign.right, // Aligns the price to the right
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 11,
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),

//           const SizedBox(height: 10),
//           //display the total price to 2 decimal places
//           //display a line break
//           const Divider(
//             color: Colors.black,
//             height: 4,
//             indent: 25,
//             endIndent: 25,
//             thickness: 2,
//           ),
//           const SizedBox(height: 5),
//           Text(
//             "Total: \t\$${widget.totalPrice.toStringAsFixed(2)}",
//             style: const TextStyle(
//               color: Colors.deepPurple,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           const SizedBox(height: 5),
//           const Divider(
//             color: Colors.black,
//             height: 4,
//             indent: 25,
//             endIndent: 25,
//             thickness: 2,
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text("Cancel"),
//         ),
//         TextButton(
//           onPressed: () async {
//             Navigator.pop(context);
//             // Fetch the user data asynchronously
//             var snapshot = await widget._getUserData();
//             if (snapshot != null) {
//               var user = snapshot.email;
//               var currentDate = DateTime.now();
//               var formattedDate =
//                   "${currentDate.year}-${currentDate.month}-${currentDate.day}";
//               for (int i = 0; i < widget.cartItems.length; i++) {
//                 //format the total price to 2 decimal places
//                 var orderItemPrice = widget.cartItems[i].price *
//                     widget.itemQuantities[widget.cartItems[i].id]!;
//                 var orderItem = Orders(
//                   orderId: currentDate.millisecondsSinceEpoch,
//                   orderDate: formattedDate,
//                   orderStatus: "Ordered",
//                   orderTotal: double.parse(orderItemPrice.toStringAsFixed(2)),
//                   itemId: widget.cartItems[i].id,
//                   custId: user,
//                   quantity: widget.itemQuantities[widget.cartItems[i].id]!,
//                 );
//                 orderItems.add(orderItem);
//               }
//               var existingOrdersList = <Orders>[];
//               final Future<List<Orders>> existingOrders =
//                   databaseHelper.getOrdersByUser(orderItems[0].custId);
//               existingOrders.then(
//                 (value) {
//                   existingOrdersList = value;
//                 },
//               ).whenComplete(() {
//                 //check if the item in the cart is in the existing orders list
//                 var matchedList = <Orders>[];
//                 for (var item in orderItems) {
//                   for (var order in existingOrdersList) {
//                     if (item.itemId == order.itemId &&
//                         item.custId == order.custId &&
//                         item.orderDate == order.orderDate) {
//                       matchedList.add(order);
//                     }
//                   }
//                   synchronizedCartItems.add(item);
//                 }

//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     for (Orders item in orderItems) {
//                       try {
//                         if (existingOrdersList.isEmpty) {
//                           databaseHelper
//                               .getProductStockLevel(item.itemId)
//                               .then((stockValue) {
//                             databaseHelper
//                                 .getProductQuantity(item.itemId)
//                                 .then((value) {
//                               if ((stockValue) > 5 &&
//                                   item.quantity <= (stockValue)) {
//                                 var newQuantity = stockValue - item.quantity;
//                                 databaseHelper.updateProductStockLevel(
//                                     item.itemId, newQuantity);
//                               } else {
//                                 //show snackbar if the item is out of stock
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       "The item ${item.itemId} is out of stock.",
//                                     ),
//                                     elevation: 9,
//                                     backgroundColor: Colors.red,
//                                     duration: const Duration(seconds: 2),
//                                     behavior: SnackBarBehavior.floating,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     animation: CurvedAnimation(
//                                       parent: const AlwaysStoppedAnimation(1.0),
//                                       curve: Curves.easeInOutBack,
//                                     ),
//                                   ),
//                                 );
//                               }
//                             });
//                           });
//                         }
//                       } catch (e) {
//                         print("Error adding item to the Orders table: $e");
//                       }
//                     }
//                     if (matchedList.isNotEmpty) {
//                       //Alert the user and display the items that have already been ordered. Confirm if the user wants to proceed with the making the order, then add the items to the Orders table
//                       return AlertDialog(
//                         title: const Text("Confirm Re-order of Items"),
//                         content: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Text(
//                                 "The items below had been ordered earlier Today.:"),
//                             const SizedBox(height: 4),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: matchedList.asMap().entries.map(
//                                   (entry) {
//                                     int index = entry.key;
//                                     var item = entry.value;
//                                     var quantity = item.quantity;
//                                     return Row(
//                                       mainAxisAlignment: MainAxisAlignment
//                                           .center, // Centers the Row content
//                                       children: [
//                                         // Item index
//                                         Text(
//                                           "${index + 1}.",
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         const SizedBox(
//                                             width:
//                                                 10), // Spacing between index and name

//                                         // Item name (takes some space but leaves room for price)
//                                         Expanded(
//                                           flex:
//                                               2, // Adjust to give more space to the name
//                                           child: Text(
//                                             item.itemId.toString(),
//                                             textAlign: TextAlign
//                                                 .start, // Centers the name
//                                             overflow: TextOverflow
//                                                 .ellipsis, // Truncate name if too long
//                                           ),
//                                         ),

//                                         const SizedBox(
//                                             width:
//                                                 20), // Space between name and price

//                                         // Item price (takes fixed space)
//                                         Expanded(
//                                           flex:
//                                               1, // Adjust to give space to the price
//                                           child: Text(
//                                             "\$${item.orderTotal}",
//                                             textAlign: TextAlign
//                                                 .left, // Aligns the price to the right
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 2,
//                                         ),
//                                         Expanded(
//                                           flex:
//                                               1, // Adjust to give space to the price
//                                           child: Text(
//                                             "Qty: ${quantity.toString()}",
//                                             textAlign: TextAlign.right,
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 11,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ).toList(),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             const Text(
//                                 "Do you want to proceed with the re-order?"),
//                           ],
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context); // Close the dialog
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: const Text(
//                                       "You have Cancelled the Re-Orders.\nRemove the item already ordered then place the new orders."),
//                                   duration: const Duration(seconds: 2),
//                                   elevation: 9,
//                                   backgroundColor: Colors.amber,
//                                   behavior: SnackBarBehavior.floating,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   animation: CurvedAnimation(
//                                     parent: const AlwaysStoppedAnimation(1.0),
//                                     curve: Curves.easeInOutBack,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: const Text("Close"),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               for (Orders matched in matchedList) {
//                                 synchronizedCartItems.add(matched);
//                                 matchedList.remove(matched);
//                               }

//                               for (Orders item in synchronizedCartItems) {
//                                 try {
//                                   databaseHelper
//                                       .getProductQuantity(item.itemId)
//                                       .then((value) {
//                                     databaseHelper
//                                         .getProductStockLevel(item.itemId)
//                                         .then((stockLevel) {
//                                       if (stockLevel > 5 &&
//                                           item.quantity <= (stockLevel)) {
//                                         var newQuantity =
//                                             stockLevel - item.quantity;
//                                         databaseHelper.updateProductStockLevel(
//                                             item.itemId, newQuantity);
//                                       } else {
//                                         synchronizedCartItems.remove(item);
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           SnackBar(
//                                             content: Text(
//                                                 "The item ${item.itemId} is out of stock and cannot be ordered now."),
//                                             duration:
//                                                 const Duration(seconds: 2),
//                                             elevation: 9,
//                                             behavior: SnackBarBehavior.floating,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             animation: CurvedAnimation(
//                                               parent:
//                                                   const AlwaysStoppedAnimation(
//                                                       1.0),
//                                               curve: Curves.easeInOutBack,
//                                             ),
//                                           ),
//                                         );
//                                       }
//                                     });
//                                   });
//                                 } catch (e) {
//                                   print(
//                                       "Error adding re-ordered item to the Orders table: $e");
//                                 }
//                               }
//                               Navigator.pop(context); // Close the dialog
//                             },
//                             child: const Text("Confirm"),
//                           ),
//                         ],
//                       );
//                     }
//                     return const SizedBox();
//                   },
//                 );
//                 if (synchronizedCartItems.isNotEmpty && matchedList.isEmpty) {
//                   //get the phone number of the user from a pop up dialog then navigate to the MpesaConfirmationDialog
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       var phone = "";
//                       return AlertDialog(
//                         title: const Text(
//                           "Enter your phone number to proceed\nUse the format 2547XXXXXXXX",
//                           style: TextStyle(
//                             fontSize: 15,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         content: TextField(
//                           keyboardType: TextInputType.phone,
//                           textAlign: TextAlign.center,
//                           onChanged: (value) {
//                             //get the phone number from the text field
//                             phone = value;
//                           },
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.popAndPushNamed(context, '/checkout');
//                             },
//                             child: const Text("Cancel"),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => MpesaConfirmationDialog(
//                                     cartItems: synchronizedCartItems,
//                                     totalPrice: widget.totalPrice,
//                                     phone: phone,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: const Text("Confirm"),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               });
//             } else {
//               // Show error if user data could not be fetched
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Error fetching user data"),
//                 ),
//               );
//             }
//           },
//           child: const Text("Confirm"),
//         ),
//       ],
//     );
//   }
// }

class _CheckoutWidgetState extends State<CheckoutWidget> {
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();
  var orderItems = <Orders>[];
  var synchronizedCartItems = <Orders>[]; // Final cart items after checks

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
    Navigator.pop(context);
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
        // Alert for re-order confirmation
        _showReOrderDialog(matchedList);
      } else {
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
          title: const Text("Confirm Re-order of Items"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("The items below were ordered earlier today:"),
              ...matchedList.map((order) {
                var index = matchedList.indexOf(order) + 1;
                return ListTile(
                  subtitle: Text(
                      "$index  Order_ID: ${order.orderId} ||  Qty: ${order.quantity} || Total: \$${order.orderTotal.toStringAsFixed(2)}"),
                );
              }),
              const Text("Do you want to proceed with the re-order?"),
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
            "Enter your phone number to proceed\nUse the format 2547XXXXXXXX",
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          content: TextField(
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.center,
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
                _launchMpesaCheckout(phone);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
        // return AlertDialog(
        //   title: const Text("Enter Phone Number"),
        //   content: TextField(
        //     keyboardType: TextInputType.phone,
        //     decoration: const InputDecoration(
        //         hintText: "Enter phone number in format 2547XXXXXXXX"),
        //     onSubmitted: (phoneNumber) {
        //       // Proceed with Mpesa payment using phone number
        //       Navigator.pop(context);
        //       _launchMpesaCheckout(phoneNumber);
        //     },
        //   ),
        // );
      },
    );
  }

  // Mockup method for launching Mpesa Checkout
  void _launchMpesaCheckout(String phoneNumber) {
    // Trigger Mpesa payment with synchronizedCartItems
    print(
        "Mpesa payment initiated for $phoneNumber with items: $synchronizedCartItems");
    final totalPrice = widget.totalPrice;
    MpesaConfirmationDialog(
        cartItems: synchronizedCartItems,
        totalPrice: totalPrice,
        phone: phoneNumber);
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
                                databaseHelper.insertOrder(item);
                                databaseHelper
                                    .deleteProductFromCart(item.itemId);
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
        '${phone.substring(0, 6)}****${phone.substring(phone.length - 2)}'; // show the last 2 characters (e.g., '43')
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
      print("TRANSACTION RESULT: $transactionInitialisation");
      //lets print the transaction results to console at this step
      return transactionInitialisation;
    } catch (e) {
      print("CAUGHT EXCEPTION: ${e.toString()}");
    }
  }

  lipaNaMpesa();
}
