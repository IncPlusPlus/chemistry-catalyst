import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:periodic_table/periodic_table.dart';

class ElementItem extends StatelessWidget {
  ElementItem({Key? key, required this.element}) : super(key: key);
  final ChemicalElement element;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(element.symbol ?? "No symbol selected"),
                  subtitle: Text(element.name ?? "No element selected"),
                )
              ],
            ),
          ),
        ],
      );
}
