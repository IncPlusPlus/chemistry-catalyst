import 'package:chem_catalyst/widgets.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  static const String routeName = '/2';
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second screen"),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text("Bruh!"),
      ),
    );
  }
}
