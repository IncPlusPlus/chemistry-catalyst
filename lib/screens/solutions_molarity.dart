import 'package:auto_size_text/auto_size_text.dart';
import 'package:chem_catalyst/model/element_item.dart';
import 'package:chem_catalyst/widgets.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:more/more.dart';
import 'package:periodic_table/periodic_table.dart';

class SolutionsAndMolarity extends StatefulWidget {
  static const routeName = '/4';

  const SolutionsAndMolarity({Key? key}) : super(key: key);

  @override
  _SolutionsAndMolarityState createState() => _SolutionsAndMolarityState();
}

class _SolutionsAndMolarityState extends State<SolutionsAndMolarity> {
  List<Tuple2<ChemicalElement, int>> elements = [];
  Decimal concentration = Decimal.zero;
  Decimal volume = Decimal.zero;
  Decimal mass = Decimal.zero;
  UnknownVariable solvingFor = UnknownVariable.mass;

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            ChemicalElement? element =
                await showElementPicker(context: context);
            if (element != null) {
              setState(() {
                _addElement(element);
              });
            }
          },
        ),
        appBar: AppBar(
          title: Text("Solutions & Molarity"),
        ),
        drawer: AppDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Currently calculating: '),
                      DropdownButton(
                          value: solvingFor,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                          ),
                          onChanged: (UnknownVariable? newValue) =>
                              setState(() {
                                solvingFor = newValue!;
                              }),
                          items: UnknownVariable.values
                              .map<DropdownMenuItem<UnknownVariable>>(
                                  (UnknownVariable e) => DropdownMenuItem(
                                      child: Text(e.name), value: e))
                              .toList())
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: elements.isEmpty
                  ? Center(
                      child: AutoSizeText(
                        "Add an element/compound to get started!",
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
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: false),
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

  bool _textFieldEnabled(UnknownVariable myField) {
    UnknownVariable currentlyUnknownVariable = solvingFor;
    return currentlyUnknownVariable != solvingFor;
  }
}

enum UnknownVariable { mass, concentration, volume }

extension UnknownVariableExtension on UnknownVariable {
  // Gets the name of the enum without the prefix.
  // https://stackoverflow.com/a/29567669/1687436
  String get name =>
      this.toString().substring(this.toString().indexOf('.') + 1);
}
