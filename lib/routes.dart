import 'package:flutter/material.dart';
import 'package:chem_catalyst/screens.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    HomePage.routeName: (context) => const HomePage(),
    SecondScreen.routeName: (context) => const SecondScreen(),
  };
}
