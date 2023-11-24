import './periodic_table.dart';

import './especific_exception.dart' as my_own_exception;
import 'package:string_validator/string_validator.dart' as str_validator;
import 'dart:io';
import 'dart:convert';

class Molecule implements Comparable {
  final String _formula;
  final String _name;

  Molecule({required String formula, required String name})
      : _name = name,
        _formula = formula {
    if (_validateFormula(_formula) == false) {
      throw Exception(my_own_exception.InvalidMoleculeFormula);
    }
  }

  bool _validateFormula(String formula) {
    var splitedFormula = _extractingSymbols();
    var allValidSymbols = _allValidSymbols();

    for (var formulaSymbol in splitedFormula) {
      if (!allValidSymbols.contains(formulaSymbol)) {
        return false;
      }
    }
    return true;
  }

  List<String> _extractingSymbols() {
    var fullFormula = _formula.split('');
    List<String> extractedSymbols = [];

    for (var c in fullFormula) {
      if (64 < c.codeUnits[0]) {
        if (c.codeUnits[0] < 97) {
          extractedSymbols.add(c);
        } else {
          String newSymbol = '';
          var n = extractedSymbols.length;
          newSymbol += extractedSymbols[n - 1] + c;
          extractedSymbols.removeLast();
          extractedSymbols.add(newSymbol);
        }
      }
    }
    return extractedSymbols;
  }

  List<String> _allValidSymbols() {
    var jsonData =
        jsonDecode(File('./assets/elements.json').readAsStringSync());

    List<String> allValidSymbols = [];

    for (var i in jsonData) {
      allValidSymbols.add(i['symbol']);
    }
    return allValidSymbols;
  }

  int _atomicWeight(String formula) {
    List<String> splitedFormula = formula.split('');

    List<Map<String, dynamic>>
        splitedFormulaInAnEasyWayToCalculateTheAtomicWeight =
        _atomicWeightEfficientFormulaSplitterHelper(splitedFormula);

    int weight = 0;

    for (var i in splitedFormulaInAnEasyWayToCalculateTheAtomicWeight) {
      if (i.keys.contains('weightMultiplier')) {
        weight +=
            _currentAtomWeight(i['symbol']) * int.parse(i['weightMultiplier']);
      } else {
        weight += _currentAtomWeight(i['symbol']);
      }
    }
    return weight;
  }

  List<Map<String, dynamic>> _atomicWeightEfficientFormulaSplitterHelper(
      List<String> splitedFormula) {
    List<Map<String, dynamic>> efficientlyDivided = [];

    do {
      String currentCharacter = splitedFormula[0];
      if (str_validator.isAlpha(currentCharacter) &&
          str_validator.isUppercase(currentCharacter)) {
        efficientlyDivided.add({'symbol': currentCharacter});
        splitedFormula.removeAt(0);
      } else if (str_validator.isAlpha(currentCharacter)) {
        efficientlyDivided.last['symbol'] += currentCharacter;
        splitedFormula.removeAt(0);
      } else {
        if (!efficientlyDivided.last.keys.contains('weightMultiplier')) {
          efficientlyDivided.last['weightMultiplier'] = currentCharacter;
        } else {
          efficientlyDivided.last['weightMultiplier'] += currentCharacter;
        }
        splitedFormula.removeAt(0);
      }
    } while (splitedFormula.isNotEmpty);

    return efficientlyDivided;
  }

  int _currentAtomWeight(String currentSymbol) {
    int currentAtomicWeight = 0;

    PeriodicTable.elements.forEach((_, element) {
      if (element.symbol == currentSymbol) {
        currentAtomicWeight += element.weight;
      }
    });
    return currentAtomicWeight;
  }

  String get formula => _formula;
  String get name => _name;
  int get weight => _atomicWeight(_formula);

  bool operator >(Molecule r) => weight > r.weight;
  bool operator <(Molecule r) => weight < r.weight;
  bool operator >=(Molecule r) => weight >= r.weight;
  bool operator <=(Molecule r) => weight <= r.weight;

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    if (other is Molecule) {
      return weight == other.weight;
    }
    return false;
  }

  @override
  int compareTo(other) {
    try {
      if (weight == other.weight) return 0;
      return (weight > other.weight) ? 1 : -1;
    } catch (e) {
      throw Exception(e);
    }
  }
}
