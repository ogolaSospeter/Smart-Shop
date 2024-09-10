import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshop/database/database_operations.dart';
import 'package:smartshop/models/orders.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/payments/checkout.dart';
import 'package:smartshop/themes/light_color.dart';
import 'package:smartshop/themes/theme.dart';

class ShoppingCartPage extends StatefulWidget {
  // ignore: y
  ShoppingCartPage({key}) : super(key: key);
  final DatabaseHelper db = DatabaseHelper();

  //Get the shopping cart items
  Future<List<Product>> getCartItems() async {
    return await db.getShoppingCartItems();
  }

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Product> cartItems = [];
  int totalItems = 0;
  double totalPrice = 0;
  int productQuantity = 1;

  @override
  void initState() {
    super.initState();
    _calculateCartDetails();
  }

  // Fetch and calculate cart details
  void _calculateCartDetails() async {
    List<Product> items = await widget.getCartItems();
    setState(() {
      cartItems = items;
      totalItems = items.length;
      totalPrice = items.fold(0, (sum, item) => sum + item.price);
    });
  }

  bool isdelete = false;

  Widget _cartItems() {
    return FutureBuilder<List<Product>>(
      future: widget.getCartItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _item(snapshot.data![index]);
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
                          loadingProgress == null
                              ? child
                              : const CircularProgressIndicator(),
                      errorBuilder: (context, error, stackTrace) =>
                          const RefreshProgressIndicator(),
                    ),
                    const Text(
                      'No items have been added to the cart',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ));
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _item(Product model) {
    return SizedBox(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
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
                    text: model.price.toString(),
                    fontSize: 14,
                  ),
                ],
              ),
              trailing: SizedBox(
                width: 103,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        productQuantity--;
                      },
                      icon: const Icon(
                        Icons.minimize,
                        size: 14,
                      ),
                    ),
                    Text(
                      productQuantity.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    IconButton(
                      onPressed: () {
                        productQuantity++;
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 14,
                      ),
                    )
                  ],
                ),
              ),
              // trailing: Container(
              //   width: 35,
              //   height: 35,
              //   alignment: Alignment.center,
              //   decoration: BoxDecoration(
              //     color: LightColor.lightGrey.withAlpha(150),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: TitleText(
              //     text: 'x${model.id}',
              //     fontSize: 12,
              //   ),
              // ),
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
                            //Remove the item from the cart
                            widget.db.updateProductSelection(model.id, false);
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
        //Pass the cart items and the total price to the checkout page
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CheckoutWidget(
              cartItems: cartItems,
              totalPrice: totalPrice,
            ),
          ),
        );
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
                              color: Colors.redAccent),
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
                                  widget.db
                                      .updateProductSelection(item.id, false);
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
              icon: Icon(isdelete ? Icons.delete : Icons.delete_outline),
              color: LightColor.iconColor,
              iconSize: 20,
            ),
          // const SizedBox.shrink(),
        ],
      ),
      body: Material(
        child: Container(
          padding: AppTheme.padding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _cartItems(),
                const Divider(
                  thickness: 1,
                  height: 70,
                ),
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
