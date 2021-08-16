import 'package:decimal/decimal.dart';
import 'package:more/more.dart';
import 'package:periodic_table/periodic_table.dart';

//<editor-fold desc="Grams, moles, and all the good stuff">
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
//</editor-fold>

//<editor-fold desc="Solutions and molarity">
/// For a solution, given the [concentration] (in molarity), [volume] of the
/// solution in liters, and [molarMassOfSolute], returns the mass of solute
/// needed to make the solution.
Decimal massOfSolute(
    Decimal concentration, Decimal volume, Decimal molarMassOfSolute) {
  return concentration * volume * molarMassOfSolute;
}

/// For a solution given the [massOfSolute] in grams, the [molarMassOfSolute],
/// and [volume] of the solution in liters, returns the concentration of the
/// solution (in molarity).
Decimal concentrationOfSolution(
    Decimal massOfSolute, Decimal volume, Decimal molarMassOfSolute) {
  try {
    return (massOfSolute / molarMassOfSolute) * volume;
  } catch (e) {
    print(e);
    return Decimal.zero;
  }
}

/// For a solution given the [massOfSolute] in grams, the [concentration]
/// (in molarity), and the [molarMassOfSolute], returns the volume of the
/// solution in liters.
Decimal volumeOfSolution(
    Decimal massOfSolute, Decimal concentration, Decimal molarMassOfSolute) {
  try {
    return massOfSolute / concentration / molarMassOfSolute;
  } catch (e) {
    print(e);
    return Decimal.zero;
  }
}
//</editor-fold>
