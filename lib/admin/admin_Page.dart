//The admin page to handle the admin functionalities
/*
**Based on the selection, the admin can
*1. View the list of all the users
*2. View a particular product
*3. Add a new product
*4. Update a product details
*5. Delete a product
*6. View the list of all the orders
*7. View a particular order
*8. Update the status of an order
*9. Cancel an order
*10. Initiate a refund for an order

*/

import 'package:flutter/material.dart';
import 'package:smartshop/admin/actions.dart';
import 'package:smartshop/database/firestore_database.dart';
import 'package:smartshop/models/user.dart';
import 'package:smartshop/ui/addProduct.dart';

class AdminPage extends StatefulWidget {
  AdminPage({super.key});

  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late List<Map<String, dynamic>> adminActions;

  @override
  void initState() {
    super.initState();

    // Initialize adminActions here where you can access widget.databaseHelper
    adminActions = [
      {
        'title': 'View Users',
        'icon': Icons.people,
        'action': (context) async {
          final users = await widget.databaseHelper.getUsers();
          UserList(users: users).showUserList(context);
        }
      },
      {
        'title': 'View Products',
        'icon': Icons.shopping_bag,
        'action': (context) async {
          final products = await widget.databaseHelper.getProducts();
          ProductList(products: products).showproductList(context);
        },
      },
      {
        'title': 'Add Product',
        'icon': Icons.add,
        'action': (context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewProduct(),
            ),
          );
        }
      },
      {'title': 'Update Product', 'icon': Icons.update, 'action': (context) {}},
      {'title': 'Delete Product', 'icon': Icons.delete, 'action': (context) {}},
      {
        'title': 'View Orders',
        'icon': Icons.shopping_cart,
        'action': (context) async {
          final orders = await widget.databaseHelper.getOrders();
          OrderList(orders: orders).showorderList(context);
        },
      },
      {
        'title': 'View Order',
        'icon': Icons.shopping_bag,
        'action': (context) async {
          final orders = await widget.databaseHelper.getOrders();
          showOrderDetails(context, orders);
        },
      },
      {
        'title': 'Update Order Status',
        'icon': Icons.update,
        'action': (context) {}
      },
      {
        'title': 'Cancel Order',
        'icon': Icons.cancel,
        'action': (context) async {
          final orders = await widget.databaseHelper.getOrders();
          cancelOrder(context, orders);
        }
      },
      {'title': 'Refund Order', 'icon': Icons.money, 'action': (context) {}},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Welcome Admin '),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 20,
                  children: adminActions
                      .map((action) => AdminActionWidget(
                          title: action['title'],
                          icon: action['icon'],
                          onPressed: action['action']))
                      .toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminActionWidget extends StatelessWidget {
  final String title;
  final Function(BuildContext) onPressed;
  final IconData icon;

  const AdminActionWidget(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 100,
      child: ElevatedButton(
        onPressed: () => onPressed(context),
        iconAlignment: IconAlignment.start,
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(10),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Display a modal bottom sheet to show the details of a particular user
class UserDetails {
  final User user;
  UserDetails({required this.user});
  void showUserDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User ID: ${user.id}'),
              Text('UserName: ${user.username}'),
              Text('Admin Status: ${user.isAdmin}'),
              Text('Login Status ${user.isLogged}'),
              Text('Email: ${user.email}'),
            ],
          ),
        );
      },
    );
  }
}
