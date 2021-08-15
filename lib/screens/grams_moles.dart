import 'package:chem_catalyst/model/element_item.dart';
import 'package:chem_catalyst/util/calculation_helpers.dart';
import 'package:chem_catalyst/util/unicode_helper.dart';
import 'package:chem_catalyst/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:periodic_table/periodic_table.dart';
import 'package:more/tuple.dart';
import 'package:decimal/decimal.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GramsMolesCalculator extends StatefulWidget {
  static const routeName = '/3';

  const GramsMolesCalculator({Key? key}) : super(key: key);

  @override
  _GramsMolesCalculatorState createState() => _GramsMolesCalculatorState();
}

class _GramsMolesCalculatorState extends State<GramsMolesCalculator> {
  List<Tuple2<ChemicalElement, int>> elements = [];

  /// False when calculating the number of grams, true when calculating the number of moles
  bool calculatingFromGrams = false;
  final numberInputController = TextEditingController();
  Decimal currentCalculationNumber = Decimal.zero;
  bool invalidInputNumber = false;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    numberInputController.addListener(() {
      setState(() {
        try {
          currentCalculationNumber = numberInputController.text == ""
              ? Decimal.zero
              : Decimal.parse(numberInputController.text);
          invalidInputNumber = false;
        } catch (e) {
          invalidInputNumber = true;
        }
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    numberInputController.dispose();
    super.dispose();
  }

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
        title: Text("Grams to moles + vice-versa"),
      ),
      drawer: AppDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              children: [
                AutoSizeText('Calculate...'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      "moles to grams",
                    ),
                    Switch(
                      value: calculatingFromGrams,
                      onChanged: (value) => setState(() {
                        calculatingFromGrams = value;
                      }),
                    ),
                    Center(
                        child: AutoSizeText(
                      "grams to moles",
                    )),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: AutoSizeText(
              'You have ${calculatingFromGrams ? _calculateMolesFromGrams(elements, currentCalculationNumber) : _calculateGramsFromMoles(elements, currentCalculationNumber)} ${calculatingFromGrams ? "moles" : "grams"} of ${elements.isEmpty ? '...' : _compoundFormulaString(elements)}',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: numberInputController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
              ],
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText:
                    'Amount of ${elements.isEmpty ? '...' : _compoundFormulaString(elements)} in ${calculatingFromGrams ? "grams" : "moles"}',
                errorText: invalidInputNumber
                    ? 'Invalid input. Try a normal number.'
                    : null,
              ),
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

Decimal _calculateMolesFromGrams(
    List<Tuple2<ChemicalElement, int>> elementsAndQuantities,
    Decimal amountInGrams) {
  if (calculateMolarMass(elementsAndQuantities) == Decimal.zero) {
    return Decimal.zero;
  }
  return amountInGrams / calculateMolarMass(elementsAndQuantities);
}

Decimal _calculateGramsFromMoles(
    List<Tuple2<ChemicalElement, int>> elementsAndQuantities,
    Decimal amountInMoles) {
  return calculateMolarMass(elementsAndQuantities) * amountInMoles;
}

String _compoundFormulaString(
    List<Tuple2<ChemicalElement, int>> elementsAndQuantities) {
  String out = '';
  for (Tuple2<ChemicalElement, int> i in elementsAndQuantities) {
    if (i.second > 0) {
      out += i.first.symbol;
    }
    if (i.second > 1) {
      out += UnicodeHelper.subScriptInteger(i.second);
    }
  }
  return out;
}
