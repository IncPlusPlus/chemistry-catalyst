import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:flutter/material.dart';
import 'package:periodic_table/periodic_table.dart';

class ElementWidget extends StatefulWidget {
  final void Function(ChemicalElement newElement) updateParentFunction;

  @override
  ElementWidgetState createState() => ElementWidgetState();

  ElementWidget({Key? key, required this.updateParentFunction}) : super(key: key);
}

class ElementWidgetState extends State<ElementWidget> {
  // Unused but this is required for the autocomplete API
  var keyRequiredForAddSuggestion = GlobalKey<AutoCompleteTextFieldState<ChemicalElement>>();
   ChemicalElement? selected;
  ElementWidgetState();


  void submitAndPop(ChemicalElement selectedItem, BuildContext context) {
    setState(() => {
      selected = selectedItem
    });
    widget.updateParentFunction(selectedItem);
    Navigator.of(context).pop(selectedItem);
  }

  AutoCompleteTextField<ChemicalElement> _buildAutoCompleteTextField(BuildContext context) {
    return AutoCompleteTextField(
      decoration: InputDecoration(
          hintText: "Search for an element:", suffixIcon: Icon(Icons.search),
      ),
      itemSubmitted: (item) => submitAndPop(item, context),
      key: keyRequiredForAddSuggestion,
      suggestions: periodicTable,
      itemBuilder: (context, suggestion) => Padding(
        child: ListTile(
          title: Text(suggestion.symbol),
          trailing: Text(suggestion.name),
        ),
        padding: EdgeInsets.all(8.0),
      ),
      itemSorter: (a, b) => a.number.compareTo(b.number),
      itemFilter: (suggestion, query) =>
      suggestion.symbol.toLowerCase().startsWith(query.toLowerCase()) ||
          suggestion.name.toLowerCase().startsWith(query.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text(selected?.symbol ?? "No symbol selected"),
                trailing: Text(selected?.name ?? "No element selected"),
                onTap: () => showDialog(context: context, builder: (context) {
                  return AlertDialog(content: _buildAutoCompleteTextField(context));
                },),
              )
            ],
          ),
        ),
      ],
    );
  }
}
