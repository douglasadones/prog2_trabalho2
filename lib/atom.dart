import './especific_exception.dart';
import 'dart:convert';
import 'dart:io';

class Atom {
  final String _symbol;

  Atom(this._symbol) {
    if (_validateSymbol(_symbol) == false) {
      throw Exception(InvalidSymbolArgument);
    }
  }

  bool _validateSymbol(String symbol) {
    final jsonData =
      jsonDecode(File('./assets/elements.json').readAsStringSync());

    for (var s in jsonData) {
      if (s['symbol'] == _symbol) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() => _symbol;
}
