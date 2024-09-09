//The Order history page
import 'package:flutter/material.dart';
import 'package:smartshop/models/orders.dart';

class RecentOrders extends StatefulWidget {
  const RecentOrders({super.key});

  @override
  State<RecentOrders> createState() => _RecentOrdersState();
}

class _RecentOrdersState extends State<RecentOrders> {
  final List<Order> orders = [
    Order(
      orderId: 1,
      orderDate: "12/12/2021",
      orderStatus: "Delivered",
      orderTotal: 100.0,
      itemId: 1,
      custId: "0789123456",
      quantity: 2,
    ),
    Order(
      orderId: 2,
      orderDate: "12/12/2021",
      orderStatus: "Delivered",
      orderTotal: 200.0,
      itemId: 2,
      custId: "0789123456",
      quantity: 1,
    ),
  ];

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
              for (var order in orders)
                OrderCard(
                  order: order,
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
