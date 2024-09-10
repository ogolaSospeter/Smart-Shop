// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:smartshop/database/database_operations.dart';
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

  bool _obscurePassword = true;
  final DatabaseHelper databaseHelper = DatabaseHelper();

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
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter username.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
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
              const SizedBox(height: 60),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
                          final user = await databaseHelper
                              .getUserByUserName(_controllerUsername.text);

                          if (user != null &&
                              user.password == _controllerPassword.text) {
                            await databaseHelper.loginUser(user.username);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Login Successful. Welcome back'),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                                elevation: 10,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                animation: CurvedAnimation(
                                  parent: const AlwaysStoppedAnimation(1.0),
                                  curve: Curves.easeInOutBack,
                                ),
                              ),
                            );
                            //delay the route for 2 seconds
                            Future.delayed(const Duration(seconds: 1), () {
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
                              const SnackBar(
                                  content:
                                      Text('User not found. Please signup')),
                            );
                            //Delay and transition to the signup page
                            Future.delayed(const Duration(seconds: 1), () {
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
                                  content:
                                      Text('Incorrect username or password')),
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
                          Future.delayed(const Duration(seconds: 2), () {
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
  }
}
