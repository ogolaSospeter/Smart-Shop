import 'package:flutter/material.dart';
import 'package:smartshop/database/firestore_database.dart';
import 'package:smartshop/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //get the email, username  from the hive box
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();

  //fetch the user data for the logged in user
  Future<User?> _getUserData() async {
    return await databaseHelper.getLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50.0,
                backgroundImage: Image.network(
                  "https://threedio-cdn.icons8.com/d9A2V6IpoSDmb_AlasKjj2lRPBSh_lwzGA5zDkToOFk/rs:fit:256:256/czM6Ly90aHJlZWRp/by1wcm9kL3ByZXZp/ZXdzLzExNy82M2Qx/NDFiNS04MjQ4LTRi/ZDQtYmQ1Mi1lNWE2/ZmI0NDBjNTMucG5n.png",
                ).image,
              ),
              FutureBuilder<User?>(
                future: _getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!.username,
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }
                  return const Text("No user");
                },
              ),
              Text(
                'Flutter Developer'.toUpperCase(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'SourceSansPro',
                  color: Colors.teal.shade100,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5,
                ),
              ),
              SizedBox(
                height: 20.0,
                width: 150,
                child: Divider(
                  color: Colors.teal.shade100,
                ),
              ),
              InkWell(
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.phone,
                        color: Colors.teal,
                      ),
                      title: Text(
                        '+254795398253',
                        style: TextStyle(
                            fontFamily: 'SourceSansPro',
                            fontSize: 20,
                            color: Colors.teal.shade900),
                      ),
                    ),
                  ),
                  onTap: () {
                    _launchURL('tel:+254795398253');
                  }),
              InkWell(
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: Colors.teal,
                    ),
                    title: FutureBuilder<User?>(
                      future: _getUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!.email,
                            style: TextStyle(
                                fontFamily: 'SourceSansPro',
                                fontSize: 18,
                                color: Colors.teal.shade900),
                          );
                        }
                        return Text(snapshot.data!.email);
                      },
                    ),
                  ),
                ),
                onTap: () {
                  FutureBuilder<User?>(
                    future: _getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _launchURL(
                          'mailto:${snapshot.data!.email}?subject=Need Flutter developer&body=Please contact me',
                        );
                      }
                      return Text(snapshot.data!.email);
                    },
                  );
                },
              ),
              //Add a card for the github account
              InkWell(
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.web,
                      color: Colors.teal,
                    ),
                    title: Text(
                      'ogolasospeter.github.io',
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 20,
                          color: Colors.teal.shade900),
                    ),
                  ),
                ),
                onTap: () {
                  _launchURL('https://ogolasospeter.github.io');
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              //Add a navigation button to the home page
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Home'),
              ),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

_launchURL(var url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
