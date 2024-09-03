import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartshop/database/database_operations.dart';
import 'package:smartshop/models/user.dart';
import 'package:smartshop/themes/theme.dart';
import 'package:smartshop/ui/product_page.dart';
import 'package:smartshop/ui/profile.dart';
import 'package:smartshop/ui/shopping_cart.dart';
import 'package:smartshop/ui/signIn.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //fetch the user name from the database
  final DatabaseHelper dbHelper = DatabaseHelper();

  //fetch the user data for the logged in user
  Future<User?> _getUserData() async {
    return await dbHelper.getLoggedInUser();
  }

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
                  'assets/jacket.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        scrolledUnderElevation: 10,
      ),
      backgroundColor: Colors.white,
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
              ListTile(
                onTap: () {
                  //Toggling the light and dark theme
                  Provider.of<ThemeNotifier>(context, listen: false)
                      .toggleTheme();
                },
                leading: const Icon(Icons.color_lens),
                title: const Text("Themes"),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ),
                  );
                },
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
              ),
              //add a profile circle avatar and the user's name in a row
              const Padding(
                padding: const EdgeInsets.only(top: 270.0),
                child: Row(
                  children: [
                    const SizedBox(width: 20.0),
                    const CircleAvatar(
                      radius: 20.0,
                      backgroundImage: AssetImage('assets/jacket.png'),
                    ),
                    const SizedBox(width: 20.0),
                    Text(
                      "Hello, \$",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1.0),
              //An arrow-down icon that when clicked pops up the logout button
              const SizedBox(height: 1.0),
            ],
          ),
        ),
      ),
      body: const MainBody(),
      // bottomNavigationBar: const BottomAppNavigation(),
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
    //Sports Rubber Shoes
    {'name': 'Sports Rubber Shoes', 'icon': 'assets/small_tilt_shoe_1.png'},
    // Rubber Shoes
    {'name': 'Rubber Shoes', 'icon': 'assets/small_tilt_shoe_2.png'},

    //Shoes
    {'name': 'Shoes', 'icon': 'assets/small_tilt_shoe_3.png'},
    //Watch
    {'name': 'Watch', 'icon': 'assets/watch.png'},
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
                                    builder: (context) => const SignIn(),
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
                    child: CategoryWidget(
                      category: category['name']!,
                      icon: category['icon']!,
                    ),
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

//reusable widget for the categories
// Create a reusable stateful widget for the categories
class CategoryWidget extends StatefulWidget {
  final String category;
  final String icon;

  const CategoryWidget({super.key, required this.category, required this.icon});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicWidth(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isSelected = !isSelected;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[200]!,
                  width: 2,
                ),
                shape: BoxShape.rectangle,
              ),
              child: ListTile(
                leading: Image.asset(
                  widget.icon,
                  height: 25,
                  width: 25,
                ),
                title: Text(widget.category),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class ProductCards extends StatelessWidget {
  const ProductCards({super.key, required this.name, required this.image});

  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return ProductPage(title: name, image: image);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const curve = Curves.easeIn;
              final curvedAnimation =
                  CurvedAnimation(parent: animation, curve: curve);

              return ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0)
                    .animate(curvedAnimation),
                child: child,
              );
            },
            transitionDuration:
                const Duration(milliseconds: 400), // Slow down the animation
          ),
        );
      },
      child: SizedBox(
        height: 200,
        width: 160,
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.only(left: 75.0, top: 5.0),
                child: Icon(Icons.favorite_outline_outlined,
                    color: Colors.red, size: 30),
              ),
              const SizedBox(height: 5),
              AspectRatio(
                aspectRatio: 1.6,
                child: Image.asset(
                  image,
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// class ProductCards extends StatelessWidget {
//   const ProductCards({super.key, required this.name, required this.image});

//   final String name;
//   final String image;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           PageRouteBuilder(
//             pageBuilder: (context, animation, secondaryAnimation) {
//               return ProductPage(title: name, image: image);
//             },
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//               const begin = Offset(0.0, 1.0);
//               const end = Offset.zero;
//               const curve = Curves.easeInOutCirc;

//               final tween =
//                   Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//               final offsetAnimation = animation.drive(tween);

//               return SlideTransition(
//                 position: offsetAnimation,
//                 child: child,
//               );
//             },
//           ),
//         );
//       },
//       child: SizedBox(
//         height: 200,
//         width: 160,
//         child: Card(
//           color: Colors.white,
//           child: Column(
//             children: [
//               const SizedBox(height: 5),
//               const Padding(
//                 padding: EdgeInsets.only(left: 75.0, top: 5.0),
//                 child: Icon(Icons.favorite_outline_outlined,
//                     color: Colors.red, size: 30),
//               ),
//               const SizedBox(height: 5),
//               AspectRatio(
//                 aspectRatio: 1.6,
//                 child: Image.asset(
//                   image,
//                   height: 150,
//                   width: 150,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               const SizedBox(height: 15),
//               Text(
//                 name,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// Widget categoryWidget(String category, String icon) {
//   bool isSelected = false;
//   return Column(
//     children: [
//       IntrinsicWidth(
//         child: GestureDetector(
//           onTap: () {
//             isSelected = !isSelected;
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color:
//                     // ignore: dead_code
//                     isSelected ? Colors.blue : Colors.grey[200]!,
//                 width: 2,
//               ),
//               shape: BoxShape.rectangle,
//             ),
//             child: ListTile(
//               leading: Image.asset(
//                 icon,
//                 height: 25,
//                 width: 25,
//               ),
//               title: Text(category),
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(height: 5),
//     ],
//   );
// }

// class ProductCards extends StatelessWidget {
//   const ProductCards({super.key, required this.name, required this.image});

//   final String name;
//   final String image;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => {
//         AnimatedTransition(
//           animation: AnimationController(vsync: this),
//           enterTransition: expandVertically(curve: Curves.easeInOutCirc),
//           exitTransition: shrinkVertically(curve: Curves.easeInOutCirc),
//           child: ProductPage(title: name, image: image),
//         ),
//         Navigator.of(context)
//             .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
//           //return the product page with the name as the title
//           return ProductPage(title: name, image: image);
//         }))
//       },
//       child: SizedBox(
//         height: 200,
//         width: 160,
//         child: Card(
//           color: Colors.white,
//           child: Column(
//             children: [
//               const SizedBox(height: 5),
//               const Padding(
//                 padding: EdgeInsets.only(left: 75.0, top: 5.0),
//                 child: Icon(Icons.favorite_outline_outlined,
//                     color: Colors.red, size: 30),
//               ),
//               const SizedBox(height: 5),
//               AnimatedVisibility(
//                 visible: true,
//                 enter: fadeIn() + slideIn(),
//                 exit: fadeOut() + slideOutHorizontally(),
//                 enterDuration: const Duration(milliseconds: 500),
//                 exitDuration: const Duration(milliseconds: 500),
//                 child: AspectRatio(
//                   aspectRatio: 1.6,
//                   child: Image.asset(
//                     image,
//                     height: 150,
//                     width: 10,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               Text(
//                 name,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }








/*
 PopupMenuButton(
                icon: const Icon(Icons.arrow_drop_down),
                onSelected: (value) {
                  if (value == 'logout') {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const Login();
                        },
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 'logout',
                      height: 10.0,
                      child: ListTile(
                        leading: Icon(
                          Icons.logout,
                        ),
                        title: Text("Logout"),
                      ),
                    ),
                  ];
                },
              ),
              */




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