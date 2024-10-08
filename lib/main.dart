import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartshop/config/routes.dart';
import 'package:smartshop/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
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
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
