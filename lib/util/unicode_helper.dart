// Character codes nabbed from https://stackoverflow.com/a/44473979/1687436
// which in turn was found from https://stackoverflow.com/a/54255383/1687436
class UnicodeHelper {
  static String superScriptInteger(int input) {
    return _toDigitArray(input)
        .map((e) => _superScriptSingleInt(e))
        .reduce((value, element) => value + element);
  }

  static String subScriptInteger(int input) {
    return _toDigitArray(input)
        .map((e) => _subScriptSingleInt(e))
        .reduce((value, element) => value + element);
  }

  static List<int> _toDigitArray(int input) {
    List<int> splitIntegers =
        input.toString().split('').map((e) => int.parse(e)).toList();
    String reproducedIntegerAsString = splitIntegers
        .map((e) => e.toString())
        .reduce((value, element) => value + element);

    // This will probably bite me in the ass later if characters get screwed up.
    // To track this bug down easier, if the integer list created isn't the actual
    // digits of the input, send out bogus (but constant) output for me to track down.
    if (int.parse(reproducedIntegerAsString) != input) {
      return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    }
    return splitIntegers;
  }

  static String _superScriptSingleInt(int input) {
    switch (input) {
      case 0:
        return '\u2070';
      case 1:
        return '\u00B9';
      case 2:
        return '\u00B2';
      case 3:
        return '\u00B3';
      case 4:
        return '\u2074';
      case 5:
        return '\u2075';
      case 6:
        return '\u2076';
      case 7:
        return '\u2077';
      case 8:
        return '\u2078';
      case 9:
        return '\u2079';
    }
    return "   !TEXT FORMATTING ISSUE!   ";
  }

  static String _subScriptSingleInt(int input) {
    switch (input) {
      case 0:
        return '\u2080';
      case 1:
        return '\u2081';
      case 2:
        return '\u2082';
      case 3:
        return '\u2083';
      case 4:
        return '\u2084';
      case 5:
        return '\u2085';
      case 6:
        return '\u2086';
      case 7:
        return '\u2087';
      case 8:
        return '\u2088';
      case 9:
        return '\u2089';
    }
    return "   !TEXT FORMATTING ISSUE!   ";
  }
}
