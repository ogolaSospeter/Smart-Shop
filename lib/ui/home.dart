// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartshop/admin/admin_Page.dart';
import 'package:smartshop/database/firestore_database.dart';
import 'package:smartshop/models/user.dart';
import 'package:smartshop/themes/theme.dart';
import 'package:smartshop/ui/main_page.dart';
import 'package:smartshop/ui/profile.dart';
import 'package:smartshop/ui/recent_orders.dart';
import 'package:smartshop/ui/shopping_cart.dart';
import 'package:smartshop/ui/signIn.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //fetch the user name from the database
  final FirestoreDatabaseHelper dbHelper = FirestoreDatabaseHelper();

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
                child: Image.network(
                  "https://threedio-cdn.icons8.com/d9A2V6IpoSDmb_AlasKjj2lRPBSh_lwzGA5zDkToOFk/rs:fit:256:256/czM6Ly90aHJlZWRp/by1wcm9kL3ByZXZp/ZXdzLzExNy82M2Qx/NDFiNS04MjQ4LTRi/ZDQtYmQ1Mi1lNWE2/ZmI0NDBjNTMucG5n.png",
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const CircularProgressIndicator();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
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
                  DropdownButton<String>(
                    items: const [
                      DropdownMenuItem(
                        value: "Light Theme",
                        child: Text("Light Theme"),
                      ),
                      DropdownMenuItem(
                        value: "Dark Theme",
                        child: Text("Dark Theme"),
                      ),
                    ],
                    onChanged: (String? value) {
                      if (value == "Light Theme") {
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .setLightMode(true);
                      } else if (value == "Dark Theme") {
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .setDarkMode(true);
                      }
                    },
                  );

                  //Toggling the light and dark theme
                  // Provider.of<ThemeNotifier>(context, listen: false)
                  //     .toggleTheme();
                },
                leading: const Icon(Icons.color_lens),
                title: const Text("Themes"),
              ),
              //If the user is an admin, show the admin page
              FutureBuilder<User?>(
                future: _getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final user = snapshot.data;
                    final isTrueAdmin = user!.isAdmin == true ? true : false;
                    if (isTrueAdmin) {
                      const Divider();
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return AdminPage();
                              },
                            ),
                          );
                        },
                        leading: const Icon(Icons.admin_panel_settings),
                        title: const Text("Admin Management"),
                      );
                    } else {
                      return const SizedBox();
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: ListTile(
                  onTap: () async {
                    // Logout the user
                    try {
                      // Fetch user data
                      final user = await _getUserData();

                      if (user != null) {
                        // Call your DB helper to log out the user
                        await dbHelper.logoutUser(user.username);

                        // Show logout success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "User ${user.username} logged out successfully")),
                        );
                      } else {
                        // Show failure message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User log out failed")),
                        );
                      }

                      // Navigate to the SignIn page after a delay
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignIn(),
                          ),
                        );
                      });
                    } catch (e) {
                      // Handle errors
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("An error occurred during logout")),
                      );
                    }
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
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: Image.network(
                        "https://threedio-cdn.icons8.com/d9A2V6IpoSDmb_AlasKjj2lRPBSh_lwzGA5zDkToOFk/rs:fit:256:256/czM6Ly90aHJlZWRp/by1wcm9kL3ByZXZp/ZXdzLzExNy82M2Qx/NDFiNS04MjQ4LTRi/ZDQtYmQ1Mi1lNWE2/ZmI0NDBjNTMucG5n.png",
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const CircularProgressIndicator(),
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      ).image,
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
            label: "Recents",
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        onTap: (index) async {
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
            var user = await _getUserData();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return RecentOrders(custId: user!.email);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
