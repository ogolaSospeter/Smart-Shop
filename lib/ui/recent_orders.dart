//The Order history page
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartshop/database/database_operations.dart';
import 'package:smartshop/models/orders.dart';
import 'package:smartshop/models/user.dart';

class RecentOrders extends StatefulWidget {
  RecentOrders({super.key, required this.custId});

  final String custId;
  final DatabaseHelper databaseHelper = DatabaseHelper();

  //get the user data for the logged in user
  Future<User?> _getUserData() async {
    return await databaseHelper.getLoggedInUser();
  }

  Future<List<Order>> _getOrders() async {
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
          "Order History",
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
              FutureBuilder<List<Order>>(
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

//The Order card
class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minTileHeight: MediaQuery.of(context).size.height * 0.22,
        leading: Image.network(
          "httpss://ouch-cdn2.icons8.com/nFPSNor92kar56WmrwhLSu3nBL_9a83B372724enXVE/rs:fit:368:368/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvOTU2/L2NlNTgxZTA4LTk3/NDEtNDE3Yi1iMTFh/LTdjYTdlZjZiNDFm/ZC5wbmc.png",
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return const CircularProgressIndicator(
              color: Colors.grey,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        subtitle: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date: \t\t\t${order.orderDate}"),
                Text("Quantity: \t\t\t${order.quantity}"),
                Text(
                    "Total: ${(order.orderTotal * order.quantity).toStringAsFixed(2)}"),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Delivery Status",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                ChoiceChip.elevated(
                  label: Text(order.orderStatus),
                  selected: true,
                  showCheckmark: false,
                  avatar: const Icon(CupertinoIcons.app),
                ),
              ],
            ),
          ],
        ),
        trailing: const ChoiceChip.elevated(
          label: Text(
            "Paid",
            selectionColor: Colors.white,
          ),
          selected: true,
          backgroundColor: Colors.green,
          selectedColor: Colors.green,
          showCheckmark: true,
          avatar: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
