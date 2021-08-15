import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:flutter/material.dart';
import 'package:periodic_table/periodic_table.dart';

// Unused but this is required for the autocomplete API
var _keyRequiredForAddSuggestion =
    GlobalKey<AutoCompleteTextFieldState<ChemicalElement>>();

AutoCompleteTextField<ChemicalElement> _buildAutoCompleteTextField(
    BuildContext context) {
  return AutoCompleteTextField(
    decoration: InputDecoration(
      hintText: "Search for an element:",
      suffixIcon: Icon(Icons.search),
    ),
    itemSubmitted: (item) => Navigator.pop(context, item),
    key: _keyRequiredForAddSuggestion,
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

Future<ChemicalElement?> showElementPicker({
  required BuildContext context,
}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: _buildAutoCompleteTextField(context),
    ),
  );
}
