import 'package:chem_catalyst/widgets.dart';
import 'package:flutter/material.dart';

class MolarMass extends StatelessWidget {
  static const String routeName = '/2';
  const MolarMass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Molar Mass"),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text("Bruh!"),
      ),
    );
  }
}
