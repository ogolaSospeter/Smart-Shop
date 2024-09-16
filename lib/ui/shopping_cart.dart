import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshop/database/firestore_database.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/payments/checkout.dart';
import 'package:smartshop/themes/light_color.dart';
import 'package:smartshop/themes/theme.dart';

// class ShoppingCartPage extends StatefulWidget {
//   // ignore: y
//   ShoppingCartPage({key}) : super(key: key);
//   final DatabaseHelper db = DatabaseHelper();

//   //Get the shopping cart items
//   Future<List<Product>> getCartItems() async {
//     return await db.getShoppingCartItems();
//   }

//   @override
//   State<ShoppingCartPage> createState() => _ShoppingCartPageState();
// }

// class _ShoppingCartPageState extends State<ShoppingCartPage> {
//   List<Product> cartItems = [];
//   Map<int, int> itemQuantities =
//       {}; // Store quantities for each item by product ID
//   int totalItems = 0;
//   double totalPrice = 0;

//   @override
//   void initState() {
//     super.initState();
//     _calculateCartDetails();
//   }

//   // Fetch and calculate cart details
//   void _calculateCartDetails() async {
//     List<Product> items = await widget.getCartItems();
//     setState(() {
//       cartItems = items;
//       totalItems = items.length;
//       totalPrice = items.fold(0, (sum, item) {
//         int quantity = itemQuantities[item.id] ?? 1; // Default to 1 if not set
//         return sum + (item.price * quantity);
//       });
//     });
//   }

//   bool isdelete = false;

//   Widget _cartItems() {
//     return FutureBuilder<List<Product>>(
//       future: widget.getCartItems(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             return ListView.builder(
//               shrinkWrap: true,
//               primary: false,
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return _item(snapshot.data![index]);
//               },
//             );
//           } else {
//             return SizedBox(
//               height: MediaQuery.of(context).size.height * .6,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Image.network(
//                     "https://threedio-cdn.icons8.com/CXxmo8CW6ZgmvcmrtJzwrNvzcHrZOGj3kyIS_M2W5Oc/rs:fit:1024:1024/czM6Ly90aHJlZWRp/by1wcm9kL3ByZXZp/ZXdzLzgxNS80YTg1/YmY3MC0xNGRmLTQw/ZmQtYTE5YS0xM2Vj/ZTU4NzZjNWMucG5n.png",
//                     height: 150,
//                     loadingBuilder: (context, child, loadingProgress) =>
//                         loadingProgress == null
//                             ? child
//                             : const CircularProgressIndicator(),
//                     errorBuilder: (context, error, stackTrace) =>
//                         const RefreshProgressIndicator(),
//                   ),
//                   const Text(
//                     'No items have been added to the cart',
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             );
//           }
//         }
//         return const CircularProgressIndicator();
//       },
//     );
//   }

class ShoppingCartPage extends StatefulWidget {
  ShoppingCartPage({super.key});
  final FirestoreDatabaseHelper db = FirestoreDatabaseHelper();

  Future<List<Product>> getCartItems() async {
    return await db.getShoppingCartItems();
  }

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Product> cartItems = [];
  Map<String, int> itemQuantities = {};
  int totalItems = 0;
  double totalPrice = 0;
  var isFetching = false;

  @override
  void initState() {
    super.initState();

    _calculateCartDetails();
  }

  void _calculateCartDetails() async {
    isFetching = true;
    List<Product> items = await widget.getCartItems();
    setState(() {
      cartItems = items;
      itemQuantities = {
        for (var item in items) item.id: 1
      }; // Initialize quantities
      _updateTotal();
    });
    isFetching = false;
  }

  void _updateTotal() {
    setState(() {
      totalItems = cartItems.length;
      totalPrice = cartItems.fold(0, (sum, item) {
        int quantity = itemQuantities[item.id] ?? 1;
        return sum + (item.price * quantity);
      });
    });
  }

  void _updateItemQuantity(String productId, int newQuantity) {
    setState(() {
      itemQuantities[productId] = newQuantity;
      _updateTotal();
    });
  }

  void _removeItem(String productId) {
    setState(() {
      widget.db.deleteProductFromCart(productId);
      itemQuantities.remove(productId);
      _calculateCartDetails();
      _updateTotal();
    });
  }

  bool isdelete = false;

  Widget _cartItems() {
    if (cartItems.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return CartItem(
            product: item,
            quantity: itemQuantities[item.id] ?? 1,
            onQuantityChanged: _updateItemQuantity,
            onRemove: _removeItem,
          );
        },
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .6,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              "https://threedio-cdn.icons8.com/CXxmo8CW6ZgmvcmrtJzwrNvzcHrZOGj3kyIS_M2W5Oc/rs:fit:1024:1024/czM6Ly90aHJlZWRp/by1wcm9kL3ByZXZp/ZXdzLzgxNS80YTg1/YmY3MC0xNGRmLTQw/ZmQtYTE5YS0xM2Vj/ZTU4NzZjNWMucG5n.png",
              height: 150,
              loadingBuilder: (context, child, loadingProgress) =>
                  const CircularProgressIndicator(),
              errorBuilder: (context, error, stackTrace) =>
                  const RefreshProgressIndicator(),
            ),
            const Text(
              'No items have been added to the cart',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  Widget _item(Product model) {
    int currentQuantity =
        itemQuantities[model.id] ?? 1; // Default quantity to 1
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.network(
                    height: 70,
                    width: 70,
                    model.image,
                    colorBlendMode: BlendMode.modulate,
                    color: LightColor.lightGrey,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image);
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListTile(
              title: TitleText(
                text: model.name,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              subtitle: Row(
                children: [
                  const TitleText(
                    text: '\$ ',
                    color: Colors.purple,
                    fontSize: 12,
                  ),
                  TitleText(
                    text: (model.price * currentQuantity).toStringAsFixed(2),
                    fontSize: 14,
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      size: 20,
                    ),
                    onPressed: () {
                      if (currentQuantity > 1) {
                        setState(() {
                          _updateItemQuantity(model.id, currentQuantity - 1);
                        });
                      }
                    },
                  ),
                  TitleText(
                    text: currentQuantity.toString(),
                    fontSize: 14,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _updateItemQuantity(model.id, currentQuantity + 1);
                      });
                    },
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Remove Item'),
                      content: const Text(
                          'Are you sure you want to remove this item from the cart?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            print(
                                "Removing item ${model.id} from cart with cartItems: $cartItems");
                            widget.db.deleteProductFromCart(model.id);
                            _calculateCartDetails();
                            print(
                                "Removed item ${model.id} from cart with cartItems: $cartItems");
                            Navigator.of(context).pop();
                          },
                          child: const Text('Remove'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _price() {
    if (totalItems == 0) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TitleText(
          text: '$totalItems items',
          color: LightColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        TitleText(
          text: '\$${totalPrice.toStringAsFixed(2)}',
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    if (totalItems == 0) {
      return const SizedBox.shrink();
    }
    return TextButton(
      onPressed: () {
        // Pass the cart items and the total price to the checkout page
        //if no item is selected, set the itemQuantities to 1 each based on the cartItems
        if (itemQuantities.isEmpty) {
          for (Product item in cartItems) {
            itemQuantities[item.id] = 1;
          }
        } else {
          print("Items passed for checkout: ${cartItems.cast()}\n\n");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  //modify the cartitems price to 2 decimal places
                  CheckoutWidget(
                cartItems: cartItems,
                totalPrice: totalPrice,
                itemQuantities: itemQuantities, // Pass the selected quantities
              ),
            ),
          );
        }
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(Colors.deepPurple),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 4),
        width: AppTheme.fullWidth(context) * .75,
        child: const TitleText(
          text: 'Proceed to Checkout',
          color: LightColor.background,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).popAndPushNamed("/home");
          },
          icon: const Icon(CupertinoIcons.arrow_left),
        ),
        notificationPredicate: (notification) => true,
        backgroundColor: LightColor.background,
        actions: [
          if (totalItems > 0)
            IconButton.outlined(
              onPressed: () {
                setState(
                  () {
                    isdelete = !isdelete;
                    //set the isselect of all items to false
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Remove Items'),
                          icon: const Icon(CupertinoIcons.delete_solid,
                              color: Colors.red),
                          content: const Text(
                              'Are you sure you want to remove all items from the cart?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                for (Product item in cartItems) {
                                  widget.db.deleteProductFromCart(item.id);
                                }
                                _calculateCartDetails();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Remove'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              icon: Icon(isdelete
                  ? CupertinoIcons.delete_solid
                  : CupertinoIcons.delete_solid),
              color: Colors.red,
              iconSize: 20,
            ),
          // const SizedBox.shrink(),
        ],
      ),
      body: isFetching
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.green,
                ),
                SizedBox(height: 20),
                Text("Fetching cart items..."),
              ],
            ))
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                height: AppTheme.fullHeight(context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _cartItems(),
                      const SizedBox(height: 20),
                      _price(),
                      const SizedBox(height: 30),
                      _submitButton(context),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class CartItem extends StatefulWidget {
  final Product product;
  final int quantity;
  final Function(String, int) onQuantityChanged;
  final Function(String) onRemove;

  const CartItem({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int currentQuantity;

  @override
  void initState() {
    super.initState();
    currentQuantity = widget.quantity;
  }

  void _updateQuantity(int newQuantity) {
    setState(() {
      currentQuantity = newQuantity;
      widget.onQuantityChanged(widget.product.id, newQuantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.network(
                    height: 70,
                    width: 70,
                    widget.product.image,
                    colorBlendMode: BlendMode.modulate,
                    color: LightColor.lightGrey,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image);
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListTile(
              title: TitleText(
                text: widget.product.name,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              subtitle: Row(
                children: [
                  const TitleText(
                    text: '\$ ',
                    color: Colors.purple,
                    fontSize: 12,
                  ),
                  TitleText(
                    text: (widget.product.price * currentQuantity)
                        .toStringAsFixed(2),
                    fontSize: 14,
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      size: 20,
                    ),
                    onPressed: () {
                      if (currentQuantity > 1) {
                        _updateQuantity(currentQuantity - 1);
                      }
                    },
                  ),
                  TitleText(
                    text: currentQuantity.toString(),
                    fontSize: 14,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 20,
                    ),
                    onPressed: () {
                      _updateQuantity(currentQuantity + 1);
                    },
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Remove Item'),
                      content: const Text(
                          'Are you sure you want to remove this item from the cart?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.onRemove(widget.product.id);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Remove'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:smartshop/database/database_operations.dart';
// import 'package:smartshop/models/orders.dart';
// import 'package:smartshop/models/product.dart';
// import 'package:smartshop/payments/checkout.dart';
// import 'package:smartshop/themes/light_color.dart';
// import 'package:smartshop/themes/theme.dart';

// class ShoppingCartPage extends StatefulWidget {
//   // ignore: y
//   ShoppingCartPage({key}) : super(key: key);
//   final DatabaseHelper db = DatabaseHelper();

//   //Get the shopping cart items
//   Future<List<Product>> getCartItems() async {
//     return await db.getShoppingCartItems();
//   }

//   @override
//   State<ShoppingCartPage> createState() => _ShoppingCartPageState();
// }

// class _ShoppingCartPageState extends State<ShoppingCartPage> {
//   List<Product> cartItems = [];
//   int totalItems = 0;
//   double totalPrice = 0;
//   int productQuantity = 1;

//   @override
//   void initState() {
//     super.initState();
//     _calculateCartDetails();
//   }

//   // Fetch and calculate cart details
//   void _calculateCartDetails() async {
//     List<Product> items = await widget.getCartItems();
//     setState(() {
//       cartItems = items;
//       totalItems = items.length;
//       totalPrice = items.fold(0, (sum, item) => sum + item.price);
//     });
//   }

//   bool isdelete = false;

//   Widget _cartItems() {
//     return FutureBuilder<List<Product>>(
//       future: widget.getCartItems(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             return ListView.builder(
//               shrinkWrap: true,
//               primary: false,
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return _item(snapshot.data![index]);
//               },
//             );
//           } else {
//             return SizedBox(
//                 height: MediaQuery.of(context).size.height * .6,
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Image.network(
//                       "https://threedio-cdn.icons8.com/CXxmo8CW6ZgmvcmrtJzwrNvzcHrZOGj3kyIS_M2W5Oc/rs:fit:1024:1024/czM6Ly90aHJlZWRp/by1wcm9kL3ByZXZp/ZXdzLzgxNS80YTg1/YmY3MC0xNGRmLTQw/ZmQtYTE5YS0xM2Vj/ZTU4NzZjNWMucG5n.png",
//                       height: 150,
//                       loadingBuilder: (context, child, loadingProgress) =>
//                           loadingProgress == null
//                               ? child
//                               : const CircularProgressIndicator(),
//                       errorBuilder: (context, error, stackTrace) =>
//                           const RefreshProgressIndicator(),
//                     ),
//                     const Text(
//                       'No items have been added to the cart',
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ));
//           }
//         }
//         return const CircularProgressIndicator();
//       },
//     );
//   }

//   Widget _item(Product model) {
//     return SizedBox(
//       height: 80,
//       width: MediaQuery.of(context).size.width,
//       child: Row(
//         children: [
//           AspectRatio(
//             aspectRatio: 1.2,
//             child: Stack(
//               children: [
//                 Align(
//                   alignment: Alignment.bottomLeft,
//                   child: SizedBox(
//                     height: 70,
//                     width: 70,
//                     child: Image.network(
//                       height: 70,
//                       width: 70,
//                       model.image,
//                       colorBlendMode: BlendMode.modulate,
//                       color: LightColor.lightGrey,
//                       fit: BoxFit.fill,
//                       errorBuilder: (context, error, stackTrace) {
//                         return const Icon(Icons.broken_image);
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListTile(
//               title: TitleText(
//                 text: model.name,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//               ),
//               subtitle: Row(
//                 children: [
//                   const TitleText(
//                     text: '\$ ',
//                     color: Colors.purple,
//                     fontSize: 12,
//                   ),
//                   TitleText(
//                     text: model.price.toString(),
//                     fontSize: 14,
//                   ),
//                 ],
//               ),

//               // trailing: Container(
//               //   width: 35,
//               //   height: 35,
//               //   alignment: Alignment.center,
//               //   decoration: BoxDecoration(
//               //     color: LightColor.lightGrey.withAlpha(150),
//               //     borderRadius: BorderRadius.circular(10),
//               //   ),
//               //   child: TitleText(
//               //     text: 'x${model.id}',
//               //     fontSize: 12,
//               //   ),
//               // ),
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       title: const Text('Remove Item'),
//                       content: const Text(
//                           'Are you sure you want to remove this item from the cart?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text('Cancel'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             //Remove the item from the cart
//                             widget.db.updateProductSelection(model.id, false);
//                             _calculateCartDetails();
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text('Remove'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _price() {
//     if (totalItems == 0) {
//       return const SizedBox.shrink();
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         TitleText(
//           text: '$totalItems items',
//           color: LightColor.grey,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//         TitleText(
//           text: '\$${totalPrice.toStringAsFixed(2)}',
//           fontSize: 18,
//         ),
//       ],
//     );
//   }

//   Widget _submitButton(BuildContext context) {
//     if (totalItems == 0) {
//       return const SizedBox.shrink();
//     }
//     return TextButton(
//       onPressed: () {
//         //Pass the cart items and the total price to the checkout page
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => CheckoutWidget(
//               cartItems: cartItems,
//               totalPrice: totalPrice,
//             ),
//           ),
//         );
//       },
//       style: ButtonStyle(
//         shape: WidgetStateProperty.all(
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         ),
//         backgroundColor: WidgetStateProperty.all<Color>(Colors.deepPurple),
//       ),
//       child: Container(
//         alignment: Alignment.center,
//         padding: const EdgeInsets.symmetric(vertical: 4),
//         width: AppTheme.fullWidth(context) * .75,
//         child: const TitleText(
//           text: 'Proceed to Checkout',
//           color: LightColor.background,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Shopping Cart'),
//         notificationPredicate: (notification) => true,
//         backgroundColor: LightColor.background,
//         actions: [
//           if (totalItems > 0)
//             IconButton.outlined(
//               onPressed: () {
//                 setState(
//                   () {
//                     isdelete = !isdelete;
//                     //set the isselect of all items to false
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: const Text('Remove Items'),
//                           icon: const Icon(CupertinoIcons.delete_solid,
//                               color: Colors.redAccent),
//                           content: const Text(
//                               'Are you sure you want to remove all items from the cart?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Text('Cancel'),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 for (Product item in cartItems) {
//                                   widget.db
//                                       .updateProductSelection(item.id, false);
//                                 }
//                                 _calculateCartDetails();
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Text('Remove'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 );
//               },
//               icon: Icon(isdelete ? Icons.delete : Icons.delete_outline),
//               color: LightColor.iconColor,
//               iconSize: 20,
//             ),
//           // const SizedBox.shrink(),
//         ],
//       ),
//       body: Material(
//         child: Container(
//           padding: AppTheme.padding,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 _cartItems(),
//                 const Divider(
//                   thickness: 1,
//                   height: 70,
//                 ),
//                 _price(),
//                 const SizedBox(height: 30),
//                 _submitButton(context),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const TitleText(
      {super.key,
      required this.text,
      this.fontSize = 18,
      this.color = LightColor.titleTextColor,
      this.fontWeight = FontWeight.w800});
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.mulish(
            fontSize: fontSize, fontWeight: fontWeight, color: color));
  }
}
