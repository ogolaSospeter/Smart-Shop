import 'package:flutter/material.dart';
import 'package:smartshop/database/firestore_database.dart';
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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              User user = users[index];
              IconData userIcon =
                  user.isAdmin ? Icons.admin_panel_settings : Icons.person;
              String userStatus = user.isAdmin ? 'Admin' : 'User';
              Color statusColor = user.isAdmin ? Colors.green : Colors.grey;

              return Card(
                elevation: 10,
                child: Card(
                  elevation: 15,
                  color: statusColor,
                  child: ListTile(
                    leading: Icon(userIcon, color: Colors.white),
                    trailing: Text(
                      userStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('User ID: ${user.id}'),
                          Text('Username: ${user.username}'),
                          Text('Admin Status: ${user.isAdmin}'),
                          Text('Login Status: ${user.isLogged}'),
                          Text('Email: ${user.email}'),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class OrderList {
  final List<Orders> orders;
  OrderList({required this.orders});
  void showorderList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        if (orders.isEmpty) {
          return Center(
            heightFactor: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.network(
                  "https://icons8.com/illustrations/illustration/coworking-ordering-taxi-using-a-mobile-app--animated",
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const CircularProgressIndicator(
                      color: Colors.grey,
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "There are currently no Orders",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Orders order = orders[index];
              return Card(
                elevation: 10,
                child: Card(
                  elevation: 15,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Text('order ID: ${order.orderId}'),
                        Text('item ordered: ${order.itemId}'),
                        Text('Customer Id: ${order.custId}'),
                        Text('Date of Orders: ${order.orderDate}'),
                        Text('Quantity Ordered: ${order.quantity}'),
                        Text("Total Cost: ${order.orderTotal}"),
                        Text("Orders Status: ${order.orderStatus}"),
                        const Divider(),
                      ],
                    ),
                  ),
                ),
              );
            },
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
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var product in products)
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      title: Text('Product : ${product.id} || ${product.name}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Original Price: ${product.price}',
                                      style: const TextStyle(fontSize: 12)),
                                  Text(
                                      'Discount offered: ${product.discount} %',
                                      style: const TextStyle(fontSize: 12)),
                                  Text("Rating: ${product.rating}",
                                      style: const TextStyle(fontSize: 12)),
                                  Text(
                                      "Initial Stock Level: ${product.quantity}",
                                      style: const TextStyle(fontSize: 12)),
                                  Text(
                                      "Current Stock Level: ${product.stocklevel}",
                                      style: const TextStyle(fontSize: 12)),
                                  Text(
                                      "Quantity Ordered: ${product.quantity - product.stocklevel}",
                                      style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Image.network(
                                      product.image,
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const CircularProgressIndicator(
                                          color: Colors.grey,
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text('Category: ${product.category}',
                                      style: const TextStyle(fontSize: 12)),
                                ],
                              )
                            ],
                          ),
                          const Divider(),
                          const Text("Product Description",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(product.description.substring(0, 120),
                              style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      elevation: 10,
      barrierLabel: 'Product Details',
    );
  }
}

//function to select a particular id of an order based on the order ids displayed and then display the details of that order in a floating sheet or dialog
void showOrderDetails(BuildContext context, List<Orders> orders) {
  showDialog(
    context: context,
    builder: (context) {
      if (orders.isEmpty) {
        return AlertDialog(
          icon: const Icon(Icons.error, color: Colors.red),
          title: const Text(
            'No Orders',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: const Text('There are currently no orders'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      }
      return AlertDialog(
        title: const Text(
          'Current Orders',
          textAlign: TextAlign.center,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              direction: Axis.vertical,
              children: [
                for (var order in orders)
                  OutlinedButton(
                    onPressed: () {
                      showOrderDetailsDialog(context, order);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('Id:  ${order.orderId}'),
                    ),
                  ),
              ],
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

void showOrderDetailsDialog(BuildContext context, Orders order) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Orders Details', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('order ID: ${order.orderId}'),
            Text('item ordered: ${order.itemId}'),
            Text('Customer Id: ${order.custId}'),
            Text('Date of Orders: ${order.orderDate}'),
            Text('Quantity Ordered: ${order.quantity}'),
            Text("Total Cost: ${order.orderTotal}"),
            Text("Orders Status: ${order.orderStatus}"),
            const SizedBox(height: 10),
            //Update order status button to update the order status
            Center(
              child: ElevatedButton(
                onPressed: () {
                  updateOrderStatusDialog(context, order);
                },
                child: const Text('Update Order Status'),
              ),
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
void updateOrderStatusDialog(BuildContext context, Orders order) {
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Icon(
          Icons.update,
          color: Colors.green,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current  Status: ${order.orderStatus}',
            ),
            const SizedBox(height: 10),
            //Dropdown to select the new order status

            DropdownButton<String>(
              elevation: 10,
              focusColor: Colors.green,
              autofocus: true,
              value: order.orderStatus,
              items: const [
                DropdownMenuItem(
                  value: 'Ordered',
                  alignment: Alignment.center,
                  child: Text('Orders Placed'),
                ),
                DropdownMenuItem(
                  value: 'Approved',
                  alignment: Alignment.center,
                  child: Text('Orders Confirmed'),
                ),
                DropdownMenuItem(
                  value: 'Dispatched',
                  alignment: Alignment.center,
                  child: Text('Orders Dispatched'),
                ),
                DropdownMenuItem(
                  value: 'Delivered',
                  alignment: Alignment.center,
                  child: Text('Orders Delivered'),
                ),
                DropdownMenuItem(
                  value: 'Cancelled',
                  alignment: Alignment.center,
                  child: Text('Orders Cancelled'),
                ),
                DropdownMenuItem(
                  value: 'Refund Initiated',
                  alignment: Alignment.center,
                  child: Text('Orders Refunded'),
                ),
                DropdownMenuItem(
                  value: 'Refund Completed',
                  alignment: Alignment.center,
                  child: Text('Refund Completed'),
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
            onPressed: () async {
              await databaseHelper.updateOrderStatus(
                  order.orderId, order.orderStatus);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "Orders Status Updated Successfully for Order: ${order.orderId} to ${order.orderStatus}"),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );
}

void cancelOrder(BuildContext context, List<Orders> orders) {
  //display a list of orders to cancel and then cancel the selected order
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Select the Order to Cancel'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            //Dropdown to select the order id to cancel
            DropdownButton<String>(
              elevation: 10,
              items: [
                for (var order in orders)
                  DropdownMenuItem(
                    value: order.orderId.toString(),
                    child: Text('Order ID: ${order.orderId}'),
                  ),
              ],
              onChanged: (value) {
                //cancel the order
                databaseHelper.cancelOrder(int.parse(value!));
                Navigator.pop(context);
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
