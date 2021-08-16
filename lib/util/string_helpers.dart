import 'package:chem_catalyst/util/unicode_helper.dart';
import 'package:more/more.dart';
import 'package:periodic_table/periodic_table.dart';

String compoundFormulaString(
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
