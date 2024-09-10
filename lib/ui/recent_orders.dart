//The Order history page
import 'package:flutter/material.dart';
import 'package:smartshop/database/database_operations.dart';
import 'package:smartshop/models/orders.dart';

class RecentOrders extends StatefulWidget {
  RecentOrders({super.key, required this.custId});

  final String custId;
  final DatabaseHelper databaseHelper = DatabaseHelper();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Recent Orders",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
