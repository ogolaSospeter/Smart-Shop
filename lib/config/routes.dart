import 'package:flutter/material.dart';
import 'package:smartshop/ui/signIn.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/': (_) => const SignIn(),
    };
  }
}
