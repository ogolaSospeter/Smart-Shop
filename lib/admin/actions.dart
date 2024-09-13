// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:smartshop/models/orders.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/models/user.dart';

//Display a modal bottom sheet to show the details of all the user, each user detail separated by a divider from the other
class UserList {
  final List<User> users;
  UserList({required this.users});
  void showUserList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var user in users)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User ID: ${user.id}'),
                    Text('UserName: ${user.username}'),
                    Text('Admin Status: ${user.isAdmin}'),
                    Text('Login Status ${user.isLogged}'),
                    Text('Email: ${user.email}'),
                    const Divider(),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class OrderList {
  final List<Order> orders;
  OrderList({required this.orders});
  void showorderList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var order in orders)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text('order ID: ${order.orderId}'),
                    Text('item ordered: ${order.itemId}'),
                    Text('Customer Id: ${order.custId}'),
                    Text('Date of Order: ${order.orderDate}'),
                    Text('Quantity Ordered: ${order.quantity}'),
                    Text("Total Cost: ${order.orderTotal}"),
                    Text("Order Status: ${order.orderStatus}"),
                    const Divider(),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class ProductList {
  final List<Product> products;
  ProductList({required this.products});
  void showproductList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          reverse: false,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var product in products)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      Text('product ID: ${product.id}'),
                      Text('Product Name: ${product.name}'),
                      Text('Price: ${product.price}'),
                      Text('Stock: ${product.quantity}'),
                      Text('Discount offered: ${product.discount}'),
                      Text("Rating: ${product.rating}"),
                      Text(
                          "product Description: ${product.description.substring(0, 120)}"),
                      const Divider(),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
      isScrollControlled: const bool.fromEnvironment('isScrollControlled'),
      isDismissible: const bool.fromEnvironment('isDismissible'),
      enableDrag: const bool.fromEnvironment('enableDrag'),
      elevation: 10,
    );
  }
}

//function to select a particular id of an order based on the order ids displayed and then display the details of that order in a floating sheet or dialog
void showOrderDetails(BuildContext context, List<Order> orders) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Select Order ID'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var order in orders)
              ListTile(
                title: Text('Order ID: ${order.orderId}'),
                onTap: () {
                  showOrderDetailsDialog(context, order);
                },
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

void showOrderDetailsDialog(BuildContext context, Order order) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Order Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('order ID: ${order.orderId}'),
            Text('item ordered: ${order.itemId}'),
            Text('Customer Id: ${order.custId}'),
            Text('Date of Order: ${order.orderDate}'),
            Text('Quantity Ordered: ${order.quantity}'),
            Text("Total Cost: ${order.orderTotal}"),
            Text("Order Status: ${order.orderStatus}"),
            const SizedBox(height: 10),
            //Update order status button to update the order status
            ElevatedButton(
              onPressed: () {
                showOrderStatusDialog(context, order);
              },
              child: const Text('Update Order Status'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

//function to update the order status of a particular order
void showOrderStatusDialog(BuildContext context, Order order) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Order Status: ${order.orderStatus}'),
            const SizedBox(height: 10),
            //Dropdown to select the new order status
            DropdownButton<String>(
              value: order.orderStatus,
              items: const [
                DropdownMenuItem(
                  value: 'Order Placed',
                  child: Text('Order Placed'),
                ),
                DropdownMenuItem(
                  value: 'Order Confirmed',
                  child: Text('Order Confirmed'),
                ),
                DropdownMenuItem(
                  value: 'Order Dispatched',
                  child: Text('Order Dispatched'),
                ),
                DropdownMenuItem(
                  value: 'Order Delivered',
                  child: Text('Order Delivered'),
                ),
              ],
              onChanged: (value) {
                order.orderStatus = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );
}
