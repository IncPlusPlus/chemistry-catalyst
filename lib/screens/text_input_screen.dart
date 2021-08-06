import 'package:chem_catalyst/widgets.dart';
import 'package:flutter/material.dart';

class TextScreen extends StatefulWidget {
  static const String routeName = '/3';

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final myController = TextEditingController();
  int yValue = 0;
  int xValue = 3;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text input"),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                print('First text field: $text');
              },
            ),
            TextField(
              controller: myController,
            ),
            Text('${myController.text} * $xValue = $yValue '),
          ],
        ),
      ),
    );
  }

  void _printLatestValue() {
    setState(() {
      yValue = int.parse(myController.text) * xValue;
    });
    print('Second text field: ${myController.text}');
  }
}
