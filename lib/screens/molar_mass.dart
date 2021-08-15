import 'package:chem_catalyst/model/element_item.dart';
import 'package:chem_catalyst/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:periodic_table/periodic_table.dart';
import 'package:more/tuple.dart';
import 'package:decimal/decimal.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MolarMass extends StatefulWidget {
  static const String routeName = '/2';

  const MolarMass({Key? key}) : super(key: key);

  @override
  _MolarMassState createState() => _MolarMassState();
}

class _MolarMassState extends State<MolarMass> {
  void _addElement(ChemicalElement element) {
    setState(() {
      // Decimal.parse(element.atomicMass.toString())
      elements.add(new Tuple2(element, 0));
    });
  }

  void _removeListItem(int index) {
    setState(() {
      elements = List.from(elements)..removeAt(index);
    });
  }

  void _setNumberOfElement(int index, int count) {
    setState(() {
      elements[index] = elements[index].withSecond(count);
    });
  }

  List<Tuple2<ChemicalElement, int>> elements = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          ChemicalElement? element = await showElementPicker(context: context);
          if (element != null) {
            setState(() {
              _addElement(element);
            });
          }
        },
      ),
      appBar: AppBar(
        title: Text("Molar Mass"),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: AutoSizeText(
              "Molar mass is ${_calculateMolarMass(elements)} g/mol",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Flexible(
            child: elements.isEmpty
                ? Center(
                    child: AutoSizeText(
                      "Add an element to get started!",
                      style: TextStyle(
                        color: Theme.of(context).unselectedWidgetColor,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: elements.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Expanded(
                            child: new ElementItem(
                                element: elements[index].first)),
                        Expanded(
                          child: new TextField(
                            decoration: InputDecoration(
                                labelText:
                                    "# moles of ${elements[index].first.name}"),
                            maxLength: 3,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: false),
                            onChanged: (value) => _setNumberOfElement(
                                index, value == "" ? 0 : int.parse(value)),
                          ),
                        ),
                        new IconButton(
                          onPressed: () => _removeListItem(index),
                          icon: Icon(Icons.remove),
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

Decimal _calculateMolarMass(
    List<Tuple2<ChemicalElement, int>> elementsAndQuantities) {
  Decimal out = Decimal.zero;
  for (Tuple2<ChemicalElement, int> i in elementsAndQuantities) {
    out += Decimal.parse(i.first.atomicMass.toString()) *
        Decimal.fromInt(i.second);
  }
  return out;
}
