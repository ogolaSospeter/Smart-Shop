import 'package:flutter/material.dart';
import 'package:smartshop/ui/product_page.dart';
import 'package:smartshop/ui/profile.dart';
import 'package:smartshop/ui/shopping_cart.dart';
import 'package:smartshop/ui/signIn.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(13)),
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0xfff8f8f8),
                      blurRadius: 10,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/profile.jpg',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          width: 230.0,
          child: Column(
            children: [
              const DrawerHeader(
                curve: Curves.bounceInOut,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: ListTile(
                  title: Text(
                    "Smart Shop",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 27.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    "Your One Stop Shopping Mall",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              //Shoppping cart
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const ShoppingCartPage();
                      },
                    ),
                  );
                },
                leading: const Icon(Icons.shopping_cart),
                title: const Text("Shopping Cart"),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const ProfileScreen();
                      },
                    ),
                  );
                },
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
              ),
              const ListTile(
                leading: Icon(Icons.color_lens),
                title: Text("Themes"),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const Login();
                      },
                    ),
                  );
                },
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
              )
            ],
          ),
        ),
      ),
      body: const MainBody(),
    );
  }
}

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final List<Map<String, String>> possibleNamesofProductsandIcons = [
    {'name': 'Hat', 'icon': 'assets/images/hat.png'},
    //skirt
    {'name': 'Skirt', 'icon': 'assets/images/skirt.png'},
    //sneaakersr
    {'name': 'Sneakers', 'icon': 'assets/images/sneakers.png'},
    //Shorts
    {'name': 'Shorts', 'icon': 'assets/categories/kidswear.png'},
    //Shoes
    {'name': 'Shoes', 'icon': 'assets/categories/shoes.png'},
    // {'name': 'Shirt', 'icon': 'https://img.icons8.com/ios/50/shirt.png'},
    // {'name': 'Trousers', 'icon': 'https://img.icons8.com/ios/50/trousers.png'},
    // {'name': 'Shoes', 'icon': 'https://img.icons8.com/ios/50/shoes.png'},
    // {'name': 'Hats', 'icon': 'https://img.icons8.com/ios/50/hat.png'},
    // {'name': 'Sneakers', 'icon': 'https://img.icons8.com/ios/50/sneakers.png'},
    // {'name': 'Suits', 'icon': 'https://img.icons8.com/ios/50/suit.png'},
    // {'name': 'Dresses', 'icon': 'https://img.icons8.com/ios/50/dress.png'},
    // {'name': 'Skirts', 'icon': 'https://img.icons8.com/ios/50/skirt.png'},
    // {
    //   'name': 'Accessories',
    //   'icon': 'https://img.icons8.com/ios/50/jewelry.png'
    // },
    // {'name': 'Bags', 'icon': 'https://img.icons8.com/ios/50/handbag.png'},
    // {'name': 'Socks', 'icon': 'https://img.icons8.com/ios/50/socks.png'},
    // {'name': 'Gloves', 'icon': 'https://img.icons8.com/ios/50/gloves.png'},
    // {'name': 'Belts', 'icon': 'https://img.icons8.com/ios/50/belt.png'},
    // {'name': 'Watches', 'icon': 'https://img.icons8.com/ios/50/watch.png'},
    // {
    //   'name': 'Sunglasses',
    //   'icon': 'https://img.icons8.com/ios/50/sunglasses.png'
    // },
    // {'name': 'Wallets', 'icon': 'https://img.icons8.com/ios/50/wallet.png'},
    // {'name': 'Ties', 'icon': 'https://img.icons8.com/ios/50/tie.png'},
    // {'name': 'Swimwear', 'icon': 'https://img.icons8.com/ios/50/swimwear.png'},
    // {'name': 'Jackets', 'icon': 'https://img.icons8.com/ios/50/jacket.png'},
    // {'name': 'Scarves', 'icon': 'https://img.icons8.com/ios/50/scarf.png'},
  ];

  //categories list
  final List<Map<String, String>> categories = [
    {
      'name': "Men Wear",
      'icon': 'assets/categories/menwear.png',
    },
    {
      'name': "Ladies Wear",
      'icon': 'assets/categories/womenwear.png',
    },
    {
      'name': "Kids Wear",
      'icon': 'assets/categories/kidswear.png',
    },
    {
      'name': "Shoes",
      'icon': 'assets/categories/shoes.png',
    },
    {
      'name': "Bags",
      'icon': 'assets/categories/bags.png',
    },
    {
      'name': "Accessories",
      'icon': 'assets/categories/accessories.png',
    },
  ];

  String selectedCategory = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Our",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              "Products",
              style: TextStyle(
                fontSize: 43,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for products",
                        border: InputBorder.none,
                        icon: IconButton(
                          onPressed: () {
                            GestureDetector(
                              onTap: () => {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const Login();
                                    },
                                  ),
                                ),
                              },
                            );
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt_outlined),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            //add a list of clothes/ wearables with each item in a card and with a leading icon
            const Text(
              "Categories",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            //the categories include Shirts, Trousers, Shoes, Hats, Sneakers, Suits, Dresses, Skirts, and Accessories
            //use a scrollable row to display the categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: categoryWidget(category['name']!, category['icon']!),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Featured ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                Wrap(
                  children: possibleNamesofProductsandIcons.map((product) {
                    return ProductCards(
                      name: product['name']!,
                      image: product['icon']!,
                    );
                  }).toList(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//create a reusable widget for the categories
Widget categoryWidget(String category, String icon) {
  return Column(
    children: [
      Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blue,
            width: 1,
          ),
          shape: BoxShape.rectangle,
        ),
        child: ListTile(
          leading: Image.asset(
            icon,
            height: 25,
            width: 25,
          ),
          title: Text(category),
        ),
      ),
      const SizedBox(height: 5),
    ],
  );
}

class ProductCards extends StatelessWidget {
  const ProductCards({super.key, required this.name, required this.image});

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      width: 160,
      child: GestureDetector(
        onTap: () => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            //return the product page with the name as the title
            return ProductPage(title: name, image: image);
          }))
        },
        child: Card(
          child: Column(
            children: [
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 75.0, top: 5.0),
                child: Icon(Icons.favorite_outline_outlined,
                    color: Colors.red, size: 30),
              ),
              const SizedBox(height: 5),
              Image.asset(
                image,
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 15),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}













/*
     const Text(
          "Categories",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Grocery"),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.fastfood,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Food"),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.local_drink,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Drinks"),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Popular",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Grocery"),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.fastfood,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Food"),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.local_drink,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Drinks"),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
*/