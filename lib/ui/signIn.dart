// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:smartshop/config/network.dart';
import 'package:smartshop/database/firestore_database.dart';
import 'package:smartshop/ui/signUp.dart';

import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    super.key,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool isAuthenticating = false;

  bool _obscurePassword = true;
  final FirestoreDatabaseHelper databaseHelper = FirestoreDatabaseHelper();
  var networkStatus;
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  @override
  void initState() {
    super.initState();

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty &&
          (results.first == ConnectivityResult.mobile ||
              results.first == ConnectivityResult.wifi)) {
        networkStatus = true;
        print("Connected to the internet");
      } else {
        networkStatus = false;
        print("No internet connection");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 70),
              Image.asset(
                "assets/login.gif",
                height: 200,
              ),
              const SizedBox(height: 2),
              Text(
                "Welcome back",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "SignIn to your account",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _controllerUsername,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                autofocus: false,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter username.";
                  }
                  return null;
                },
                //Only show the keyboard once the user taps the textfield
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                //hide the keyboard when the user taps the done button
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_off_outlined)
                          : const Icon(Icons.visibility_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              isAuthenticating
                  ? const ListTile(
                      leading: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                      title: Text("Authenticating..."),
                      selected: true,
                      selectedColor: Colors.green,
                      textColor: Colors.green,
                      contentPadding: EdgeInsets.all(10),
                    )
                  : Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            var connectivityResult = await isNetworkAvailable();
                            print("Connectivity result: $connectivityResult");
                            if (connectivityResult == false) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ConnectionError();
                                  },
                                ),
                              );
                            } else {
                              if (_formKey.currentState?.validate() ?? false) {
                                setState(() {
                                  isAuthenticating = true;
                                });
                                try {
                                  //Display a circular progress indicator while the user is being authenticated

                                  final user =
                                      await databaseHelper.getUserByUserName(
                                          _controllerUsername.text);

                                  if (user != null &&
                                      user.password ==
                                          _controllerPassword.text) {
                                    await databaseHelper
                                        .loginUser(user.username);
                                    //asign the user status to admin or user based on the user.isAdmin value
                                    final String userStatus =
                                        user.isAdmin ? "Admin" : "User";

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '\tLogin Successful. Welcome back $userStatus ${user.username}'),
                                        backgroundColor: Colors.green,
                                        duration: const Duration(seconds: 2),
                                        elevation: 10,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        animation: CurvedAnimation(
                                          parent:
                                              const AlwaysStoppedAnimation(1.0),
                                          curve: Curves.easeInOutBack,
                                        ),
                                      ),
                                    );
                                    //delay the route for 2 seconds
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const Home();
                                          },
                                        ),
                                      );
                                    });
                                  } else if (user == null) {
                                    // User not found
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'User ${_controllerUsername.text} not registered!'),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 2),
                                        elevation: 10,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    // Delay and transition to the signup page
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const Signup();
                                          },
                                        ),
                                      );
                                    });
                                    _formKey.currentState?.reset();
                                  } else {
                                    // Incorrect username or password
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Incorrect username or password'),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.redAccent,
                                        elevation: 10,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    _formKey.currentState?.reset();
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'User ${_controllerUsername.text} not registered!'),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 2),
                                      elevation: 10,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const Signup();
                                        },
                                      ),
                                    );
                                  });
                                  _formKey.currentState?.reset();
                                } finally {
                                  setState(() {
                                    isAuthenticating = false;
                                  });
                                }
                              }
                            }
                          },
                          child: const Text("Login"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                _formKey.currentState?.reset();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const Signup();
                                    },
                                  ),
                                );
                              },
                              child: const Text("Signup"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        TextButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                          },
                          child: const Text("Forgot Password?"),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    connectivitySubscription?.cancel();
  }
}
