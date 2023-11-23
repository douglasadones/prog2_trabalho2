import 'dart:convert';
import 'dart:io';
import './element.dart';


// TODO 1 - It's not a singleton :(
class PeriodicTable {
  static var elements = _namedTeste();

  static Map<String, Element> _namedTeste() {
    var jsonData =
        jsonDecode(File('./assets/elements.json').readAsStringSync());

    Map<String, Element> listWithAllElements = {};
    var count = 0;
    for (var c in jsonData) {
      listWithAllElements[count.toString()] = Element(
          symbol: c['symbol'],
          name: c['name'],
          latinName: c['latinName'],
          weight: int.parse(c['weight']));
      count++;
    }
    return listWithAllElements;
  }
}
