//A function to get the network status of the device using the connectivity plugin

// ignore_for_file: unrelated_type_equality_checks

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult[0] == ConnectivityResult.mobile ||
      connectivityResult[0] == ConnectivityResult.wifi) {
    print(connectivityResult[0]);
    return true;
  } else {
    print(connectivityResult[0]);
    return false;
  }
}

//An connection errror page to display when there is no network connection

class ConnectionError extends StatelessWidget {
  const ConnectionError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/network.png',
                height: 200.0,
                width: 200.0,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'You are not connected to the internet. Please check your connection and try again',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  //Show a snackbar to inform the user that the app is retrying to connect to the internet and retry the connection
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      elevation: 10.0,
                      padding: EdgeInsets.all(15.0),
                      content: Text('Retrying to connect to the internet'),
                    ),
                  );
                  //Retry the connection
                  Navigator.pop(context);
                },
                child: const Text('Retry'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
