
class InvalidSymbolArgument implements Exception {
  final String? msg;

  const InvalidSymbolArgument([this.msg]);

  @override
  String toString() => msg ?? 'Invalid Symbol Argument';
}

class InvalidMoleculeFormula implements Exception {
  final String? msg;

  const InvalidMoleculeFormula([this.msg]);

  @override
  String toString() => msg ?? 'Invalid Molecule Formula';
}