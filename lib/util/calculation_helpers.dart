import 'package:decimal/decimal.dart';
import 'package:more/more.dart';
import 'package:periodic_table/periodic_table.dart';

/// Calculates the molar mass of a single element or a list of elements.
/// [elementsAndQuantities] is a list of pairs where the left side is
/// a [ChemicalElement] and the right side is the number of atoms of that
/// element present in the compound.
Decimal calculateMolarMass(
    List<Tuple2<ChemicalElement, int>> elementsAndQuantities) {
  Decimal out = Decimal.zero;
  for (Tuple2<ChemicalElement, int> i in elementsAndQuantities) {
    // Add the molar mass of the element * how many atoms there are of it
    // to the running total of the molar mass of the compound.
    out += Decimal.parse(i.first.atomicMass.toString()) *
        Decimal.fromInt(i.second);
  }
  return out;
}
