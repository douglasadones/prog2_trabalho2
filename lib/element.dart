import 'dart:convert';
import './atom.dart';

import './especific_exception.dart' as my_own_exception;
import 'dart:io';

class Element {
  final String _symbol;
  final String _name;
  final String _latinName;
  final int _weight;

  Element({
    required String symbol,
    required String name,
    required String latinName,
    required int weight,
  })  : _weight = weight,
        _latinName = latinName,
        _name = name,
        _symbol = symbol {
    if (_validateSymbol(_symbol) == false) {
      throw Exception(my_own_exception.InvalidSymbolArgument);
    }
  }

  bool _validateSymbol(String symbol) {
    var jsonData =
        jsonDecode(File('./assets/elements.json').readAsStringSync());
    for (var s in jsonData) {
      if (s['symbol'] == _symbol) {
        return true;
      }
    }
    return false;
  }

  String get symbol => Atom(_symbol).toString();
  String get name => _name;
  String get latinName => _latinName;
  int get weight => _weight;
}
