import 'package:auto_size_text/auto_size_text.dart';
import 'package:chem_catalyst/model/element_item.dart';
import 'package:chem_catalyst/util/calculation_helpers.dart';
import 'package:chem_catalyst/util/string_helpers.dart';
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
  late Decimal molarMass = calculateMolarMass(elements);

  final molarMassController = TextEditingController();
  final massController = TextEditingController();
  final concentrationController = TextEditingController();
  final volumeController = TextEditingController();

  bool invalidMassInput = false;
  bool invalidConcentrationInput = false;
  bool invalidVolumeInput = false;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    massController.addListener(_setMass);
    concentrationController.addListener(_setConcentration);
    volumeController.addListener(_setVolume);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    massController.dispose();
    concentrationController.dispose();
    volumeController.dispose();
    super.dispose();
  }

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                                _clearControllerValue(newValue);
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
            Center(
              child: AutoSizeText(
                "The ${solvingFor.name} of ${molarMass == Decimal.zero ? '...' : compoundFormulaString(elements)} is ${_getAnswerString()}",
                style: TextStyle(
                  color: Theme.of(context).unselectedWidgetColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      readOnly: true,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
                      ],
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                          labelText:
                              'Molar mass of ${molarMass == Decimal.zero ? '...' : compoundFormulaString(elements)}'),
                      controller: molarMassController,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
                      ],
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText:
                            'Mass of ${molarMass == Decimal.zero ? '...' : compoundFormulaString(elements)}',
                        errorText: invalidMassInput
                            ? 'Invalid input. Try a normal number.'
                            : null,
                      ),
                      controller: massController,
                      enabled: _textFieldEnabled(UnknownVariable.mass),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
                      ],
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText:
                            'Concentration of ${molarMass == Decimal.zero ? '...' : compoundFormulaString(elements)}',
                        errorText: invalidConcentrationInput
                            ? 'Invalid input. Try a normal number.'
                            : null,
                      ),
                      controller: concentrationController,
                      enabled: _textFieldEnabled(UnknownVariable.concentration),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
                      ],
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText:
                            'Volume of ${molarMass == Decimal.zero ? '...' : compoundFormulaString(elements)}',
                        errorText: invalidVolumeInput
                            ? 'Invalid input. Try a normal number.'
                            : null,
                      ),
                      controller: volumeController,
                      enabled: _textFieldEnabled(UnknownVariable.volume),
                    ),
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

  String _getAnswerString() {
    String out = _getAnswer().toString();
    switch (solvingFor) {
      case UnknownVariable.mass:
        out += ' grams';
        break;
      case UnknownVariable.concentration:
        out += ' (molarity)';
        break;
      case UnknownVariable.volume:
        out += ' liters';
        break;
    }
    return out;
  }

  Decimal _getAnswer() {
    switch (solvingFor) {
      case UnknownVariable.mass:
        return massOfSolute(concentration, volume, molarMass);
      case UnknownVariable.concentration:
        return concentrationOfSolution(mass, volume, molarMass);
      case UnknownVariable.volume:
        return volumeOfSolution(mass, concentration, molarMass);
    }
  }

  void _addElement(ChemicalElement element) {
    setState(() {
      elements.add(new Tuple2(element, 0));
      _setMolarMass();
    });
  }

  void _removeListItem(int index) {
    setState(() {
      elements = List.from(elements)..removeAt(index);
      _setMolarMass();
    });
  }

  void _setNumberOfElement(int index, int count) {
    setState(() {
      elements[index] = elements[index].withSecond(count);
      _setMolarMass();
    });
  }

  bool _textFieldEnabled(UnknownVariable myField) {
    UnknownVariable currentlyUnknownVariable = solvingFor;
    return currentlyUnknownVariable != myField;
  }

  void _setMolarMass() {
    molarMass = calculateMolarMass(elements);
    molarMassController.text =
        molarMass == Decimal.zero ? '' : molarMass.toString();
  }

  void _setMass() {
    setState(() {
      try {
        mass = massController.text == ""
            ? Decimal.zero
            : Decimal.parse(massController.text);
        invalidMassInput = false;
      } catch (e) {
        invalidMassInput = true;
      }
    });
  }

  void _setConcentration() {
    setState(() {
      try {
        concentration = concentrationController.text == ""
            ? Decimal.zero
            : Decimal.parse(concentrationController.text);
        invalidConcentrationInput = false;
      } catch (e) {
        invalidConcentrationInput = true;
      }
    });
  }

  void _setVolume() {
    setState(() {
      try {
        volume = volumeController.text == ""
            ? Decimal.zero
            : Decimal.parse(volumeController.text);
        invalidVolumeInput = false;
      } catch (e) {
        invalidVolumeInput = true;
      }
    });
  }

  void _clearControllerValue(UnknownVariable newValue) {
    switch (newValue) {
      case UnknownVariable.mass:
        massController.text = '';
        break;
      case UnknownVariable.concentration:
        concentrationController.text = '';
        break;
      case UnknownVariable.volume:
        volumeController.text = '';
        break;
    }
  }
}

enum UnknownVariable { mass, concentration, volume }

extension UnknownVariableExtension on UnknownVariable {
  // Gets the name of the enum without the prefix.
  // https://stackoverflow.com/a/29567669/1687436
  String get name =>
      this.toString().substring(this.toString().indexOf('.') + 1);
}
