import 'package:flutter/material.dart';
import 'package:chem_catalyst/screens.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    HomePage.routeName: (context) => const HomePage(),
    MolarMass.routeName: (context) => const MolarMass(),
    TextScreen.routeName: (context) => TextScreen(),
  };
}
