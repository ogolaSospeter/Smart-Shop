//The Order history page
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
        title: const Text("Recent Orders"),
      ),
      body: SingleChildScrollView(
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
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map((order) {
                        return OrderCard(order: order);
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return const Text("Error fetching orders");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    Image.network(
                      "https://ouch-cdn2.icons8.com/nFPSNor92kar56WmrwhLSu3nBL_9a83B372724enXVE/rs:fit:368:368/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvOTU2/L2NlNTgxZTA4LTk3/NDEtNDE3Yi1iMTFh/LTdjYTdlZjZiNDFm/ZC5wbmc.png",
                      width: 150,
                      height: 150,
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
                  return const Center(
                    child: CircularProgressIndicator(),
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
        title: Text("Order ID: ${order.orderId}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Date: ${order.orderDate}"),
            Text("Order Status: ${order.orderStatus}"),
            Text("Order Total: ${order.orderTotal}"),
          ],
        ),
      ),
    );
  }
}
