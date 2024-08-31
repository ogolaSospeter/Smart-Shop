import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartshop/ui/profile.dart';
import 'package:smartshop/ui/signIn.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final Box _boxLogin = Hive.box("login");

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
                  Navigator.of(context).push(
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

class MainBody extends StatelessWidget {
  const MainBody({super.key});

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
                children: [
                  categoryWidget("Shirts", Icons.shopping_bag),
                  const SizedBox(width: 20), // Spacing between boxes
                  categoryWidget("Trousers", Icons.fastfood),
                  const SizedBox(width: 20), // Spacing between boxes
                  categoryWidget("Shoes", Icons.local_drink),
                  const SizedBox(width: 20), // Spacing between boxes
                  categoryWidget("Hats", Icons.shopping_bag),
                  const SizedBox(width: 20), // Spacing between boxes
                  categoryWidget("Sneakers", Icons.fastfood),
                  const SizedBox(width: 20), // Spacing between boxes
                  categoryWidget("Suits", Icons.local_drink),
                  const SizedBox(width: 20), // Spacing between boxes
                  categoryWidget("Dresses", Icons.shopping_bag),
                  const SizedBox(width: 20), // Spacing between boxes
                  categoryWidget("Skirts", Icons.fastfood),
                  const SizedBox(width: 20), // Spacing between boxes
                  categoryWidget("Accessories", Icons.local_drink),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const ProductCards()
          ],
        ),
      ),
    );
  }
}

//create a reusable widget for the categories
Widget categoryWidget(String category, IconData icon) {
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
          leading: Icon(
            icon,
            size: 25,
            color: Colors.blue,
          ),
          title: Text(category),
        ),
      ),
      const SizedBox(height: 5),
    ],
  );
}

class ProductCards extends StatelessWidget {
  const ProductCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        height: 140,
        width: 130,
        child: Card(
          child: Column(
            children: [
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: 0.0, top: 5.0),
                child: Icon(Icons.favorite_sharp, color: Colors.red, size: 25),
              ),
              SizedBox(height: 15),
              Icon(Icons.festival_outlined, color: Colors.blue),
              SizedBox(height: 15),
              Text("Shoes"),
              SizedBox(height: 10)
            ],
          ),
        ));
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