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
        IconData userIcon = Icons.person;
        String userStatus = 'User';
        for (var user in users) {
          if (user.isAdmin) {
            userIcon = Icons.admin_panel_settings;
            userStatus = 'Admin';
          } else {
            userIcon = Icons.person;
            userStatus = 'User';
          }
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Card(
            elevation: 10,
            child: Card(
              elevation: 15,
              color: Colors.deepPurpleAccent,
              child: ListTile(
                leading: Icon(userIcon, color: Colors.white),
                trailing:
                    //add a container to show when the user is an admin or not, an icon and text to show the status of the user
                    Text(
                  userStatus,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                ),
              ),
            ),
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
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          reverse: true,
          child: Container(
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
                      Text('Date of Orders: ${order.orderDate}'),
                      Text('Quantity Ordered: ${order.quantity}'),
                      Text("Total Cost: ${order.orderTotal}"),
                      Text("Orders Status: ${order.orderStatus}"),
                      const Divider(),
                    ],
                  ),
              ],
            ),
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
        title: const Text('Select Orders ID'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.vertical,
              children: [
                for (var order in orders)
                  OutlinedButton(
                    onPressed: () {
                      showOrderDetailsDialog(context, order);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('${order.orderId}'),
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
                child: const Text('Update Orders Status'),
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
        title: const Text('Update Orders Status'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Orders Status: ${order.orderStatus}'),
            const SizedBox(height: 10),
            //Dropdown to select the new order status

            DropdownButton<String>(
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
          TextButton(
            onPressed: () async {
              await databaseHelper.updateOrderStatus(
                  order.orderId, order.orderStatus);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "Orders Status Updated Successfully for Orders ID: ${order.orderId} to ${order.orderStatus}"),
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

//Function to add a new product to the product list
void addNewProduct(BuildContext context) {
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();
  showDialog(
    context: context,
    builder: (context) {
      String productName = '',
          productCategory = '',
          productImage = '',
          productPrice = '',
          productDiscount = '',
          productDescription = '',
          productRating = '',
          productStockLevel = '';
      List<String> productSizes = [];
      List<Color> productColors = [];
      return AlertDialog(
        title: const Text('New Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Product Name'),
            TextField(
              onChanged: (value) {
                productName = value;
              },
            ),
            const Text('Product Category'),
            TextField(
              onChanged: (value) {
                productCategory = value;
              },
            ),
            const Text('Product Image'),
            TextField(
              onChanged: (value) {
                productImage = value;
              },
            ),
            const Text('Product Price'),
            TextField(
              onChanged: (value) {
                productPrice = value;
              },
            ),
            const Text('Product Discount'),
            TextField(
              onChanged: (value) {
                productDiscount = value;
              },
            ),
            const Text('Product Description'),
            TextField(
              onChanged: (value) {
                productDescription = value;
              },
            ),
            const Text('Product Rating'),
            TextField(
              onChanged: (value) {
                productRating = value;
              },
            ),
            const Text('Product Stock Level'),
            TextField(
              onChanged: (value) {
                productStockLevel = value;
              },
            ),
            //Product sizes,Colors
            const Text('Product Sizes'),
            TextField(
              onChanged: (value) {
                productSizes = value.split(',');
              },
            ),
            const Text('Product Colors'),
            TextField(
              onChanged: (value) {
                productColors = value.split(',').map((e) {
                  return Color(int.parse(e));
                }).toList();
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
              var product = Product(
                id: 00,
                name: productName,
                category: productCategory,
                image: productImage,
                price: double.parse(productPrice),
                discount: double.parse(productDiscount),
                description: productDescription,
                rating: double.parse(productRating),
                quantity: int.parse(productStockLevel),
                stocklevel: int.parse(productStockLevel),
                sizes: productSizes,
                colors: productColors,
                isCart: false,
                isLiked: false,
                isSelected: false,
              );
              await databaseHelper.insertProduct(product);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}

void cancelOrder(BuildContext context) {
  //display a list of orders to cancel and then cancel the selected order
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Select Orders ID to Cancel'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Orders ID to Cancel'),
            const SizedBox(height: 10),
            //Dropdown to select the order id to cancel
            DropdownButton<String>(
              items: const [
                DropdownMenuItem(
                  value: '1',
                  alignment: Alignment.center,
                  child: Text('1'),
                ),
                DropdownMenuItem(
                  value: '2',
                  alignment: Alignment.center,
                  child: Text('2'),
                ),
                DropdownMenuItem(
                  value: '3',
                  alignment: Alignment.center,
                  child: Text('3'),
                ),
                DropdownMenuItem(
                  value: '4',
                  alignment: Alignment.center,
                  child: Text('4'),
                ),
                DropdownMenuItem(
                  value: '5',
                  alignment: Alignment.center,
                  child: Text('5'),
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
