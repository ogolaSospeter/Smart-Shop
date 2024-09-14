import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartshop/config/routes.dart';
import 'package:smartshop/models/database_products.dart';
import 'package:smartshop/reusables/database_init.dart';
import 'package:smartshop/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    // initializeDatabase(database_products);
  } catch (e) {
    print('Error: $e');
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'My Smart One Stop Shop',
      themeMode: themeNotifier.currentTheme,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routes: Routes.getRoute(),
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: const Center(
//         child: Text(
//           'Welcome to My Smart One Stop Shop',
//         ),
//       ),
//     );
//   }
// }
