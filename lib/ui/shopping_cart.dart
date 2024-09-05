import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshop/database/database_operations.dart';
import 'package:smartshop/models/product.dart';
import 'package:smartshop/themes/light_color.dart';
import 'package:smartshop/themes/theme.dart';

class ShoppingCartPage extends StatefulWidget {
  // ignore: use_super_parameters
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
  Widget _cartItems() {
    return Column(children: [
      FutureBuilder<List<Product>>(
        future: widget.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _item(snapshot.data![index]);
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      )
    ]);
  }

  Widget _item(Product model) {
    return SizedBox(
      height: 80,
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
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Image.network(model.image),
                )
              ],
            ),
          ),
          Expanded(
              child: Material(
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
                      color: LightColor.red,
                      fontSize: 12,
                    ),
                    TitleText(
                      text: model.price.toString(),
                      fontSize: 14,
                    ),
                  ],
                ),
                trailing: Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: LightColor.lightGrey.withAlpha(150),
                      borderRadius: BorderRadius.circular(10)),
                  child: TitleText(
                    text: 'x${model.id}',
                    fontSize: 12,
                  ),
                )),
          ))
        ],
      ),
    );
  }

  Widget _price() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TitleText(
          text: '${widget.getCartItems().then((value) => value.length)} Items',
          color: LightColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        TitleText(
          text: '\$${getPrice()}',
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(LightColor.orange),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 4),
        width: AppTheme.fullWidth(context) * .75,
        child: const TitleText(
          text: 'Next',
          color: LightColor.background,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  double getPrice() {
    double price = 0;
    //iterate through the price of each product in the cart
    widget.getCartItems().then(
      (value) {
        for (var item in value) {
          price += item.price;
        }
      },
    );
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          IconButton.filled(
            onPressed: () {},
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          )
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
