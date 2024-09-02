import 'package:flutter/material.dart';
import 'package:smartshop/ui/home.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({
    super.key,
    required this.title,
    required this.image,
  });

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return Home();
                },
              ),
            );
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Image.network(
                image,
                height: 200,
                width: 300,
                color: Colors.blue,
              ),
              const SizedBox(
                height: 1.0,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 17.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
