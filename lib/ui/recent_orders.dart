//The Orders history page
// ignore_for_file: unused_element, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartshop/database/firestore_database.dart';
import 'package:smartshop/models/orders.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/models/user.dart';

class RecentOrders extends StatefulWidget {
  RecentOrders({super.key, required this.custId});

  final String custId;
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();

  //get the user data for the logged in user
  Future<User?> _getUserData() async {
    return await databaseHelper.getLoggedInUser();
  }

  Future<List<Orders>> _getOrders() async {
    return await databaseHelper.getOrdersByUser(custId);
  }

  @override
  State<RecentOrders> createState() => _RecentOrdersState();
}

class _RecentOrdersState extends State<RecentOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders History",
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              FutureBuilder<List<Orders>>(
                future: widget._getOrders(),
                builder: (context, snapshot) {
                  print(
                      "Snapshot Connection State: ${snapshot.connectionState}");
                  print("Snapshot Error: ${snapshot.error}");
                  print("Snapshot Data: ${snapshot.data}");
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Column(
                        children: snapshot.data!.map((order) {
                          return OrderCard(order: order);
                        }).toList(),
                      );
                    } else {
                      Image.network(
                        "https://threedio-cdn.icons8.com/reazbICnl7OUr8WvRYsyKl6IevulHsoIyvoD-pi6oTA/rs:fit:256:256/czM6Ly90aHJlZWRp/by1wcm9kL3ByZXZp/ZXdzLzM0NC9kYjk3/NDg4NS1kNjliLTQ2/NDItYTBhMy00YTc5/Y2FiMmY4ZjEucG5n.png",
                        width: 200,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                      const Text(
                        "No Orders",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      );
                      const SizedBox(height: 20);
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const Text("No Orders");
                  }
                  return Center(
                    child: Column(
                      children: [
                        Image.network(
                          "https://threedio-cdn.icons8.com/reazbICnl7OUr8WvRYsyKl6IevulHsoIyvoD-pi6oTA/rs:fit:256:256/czM6Ly90aHJlZWRp/by1wcm9kL3ByZXZp/ZXdzLzM0NC9kYjk3/NDg4NS1kNjliLTQ2/NDItYTBhMy00YTc5/Y2FiMmY4ZjEucG5n.png",
                          width: 200,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                        const Text(
                          "No Orders",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//The Orders card
class OrderCard extends StatelessWidget {
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();

  //Get the product name from the product id
  Future<String> _getProductName(String productId) async {
    var product = await databaseHelper.getProductById(productId);
    var productName = product!.name;
    return productName;
  }

  final Orders order;
  var orderStatuses = [
    'Ordered',
    'Approved',
    'Dispatched',
    'Delivered',
    'Cancelled',
    'Refund Initiated',
    'Refund Completed',
    'Out of Stock'
  ];
  OrderCard({super.key, required this.order});
  var orderStatusColor;
  var isShowCheckmark = false;
  var orderStatusIcon;
  var productName;

  @override
  Widget build(BuildContext context) {
    //get the product name from the future builder

    for (var i = 0; i < orderStatuses.length; i++) {
      if (order.orderStatus == orderStatuses[i]) {
        orderStatusColor = i == 0
            ? Colors.blue
            : i == 1
                ? Colors.orange
                : i == 2
                    ? Colors.purple
                    : i == 3
                        ? Colors.green
                        : i == 4
                            ? Colors.red
                            : i == 5
                                ? Colors.red
                                : i == 6
                                    ? Colors.green
                                    : i == 7
                                        ? Colors.yellow
                                        : Colors.grey;
      }
    }
    isShowCheckmark = orderStatusColor == Colors.green ? true : false;
    orderStatusIcon = orderStatusColor == Colors.green
        ? Icons.check_circle
        : orderStatusColor == Colors.red
            ? Icons.cancel
            : Icons.info;
    return Card(
      child: Center(
        heightFactor: 1.5,
        child: ListTile(
          leading: Icon(
            orderStatusIcon,
            color: orderStatusColor,
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String>(
                future: _getProductName(order.itemId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      productName = snapshot.data;
                      return Text("Product: \t$productName");
                    } else {
                      return const Text("");
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const LinearProgressIndicator();
                  } else {
                    return const Text("");
                  }
                },
              ),
              Text("Date: \t\t\t${order.orderDate}"),
              Text("Quantity: \t\t\t${order.quantity}"),
              Text("Total: \$${(order.orderTotal).toStringAsFixed(2)}"),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
          trailing: Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: ChoiceChip.elevated(
              label: Text(order.orderStatus,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: order.orderStatus == orderStatuses[7]
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  )),
              selected: false,
              showCheckmark: isShowCheckmark,
              disabledColor: orderStatusColor,
              avatar: const Icon(CupertinoIcons.app),
            ),
          ),
        ),
      ),
    );
  }
}
