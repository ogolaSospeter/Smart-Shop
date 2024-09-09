import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartshop/database/database_operations.dart';
import 'package:smartshop/models/user.dart';
import 'package:smartshop/themes/theme.dart';
import 'package:smartshop/ui/main_page.dart';
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
                        return ShoppingCartPage();
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
              Padding(
                padding: const EdgeInsets.only(top: 270.0),
                child: ListTile(
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
              ),
              //add a profile circle avatar and the user's name in a row
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    const SizedBox(width: 20.0),
                    const CircleAvatar(
                      radius: 20.0,
                      backgroundImage: AssetImage('assets/jacket.png'),
                    ),
                    const SizedBox(width: 20.0),
                    FutureBuilder<User?>(
                      future: _getUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            "Hello, ${snapshot.data!.username}",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const Text(
                            "Hello User",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const Home();
                },
              ),
            );
          } else if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ShoppingCartPage();
                },
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const ProfileScreen();
                },
              ),
            );
          }
        },
      ),
    );
  }
}
