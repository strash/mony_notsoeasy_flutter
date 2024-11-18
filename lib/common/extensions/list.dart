extension ListEx<T extends Object?> on List<T> {
  V foldValue<V extends Object>(
    V initialValue,
    V Function(T? previous, T current) combine,
  ) {
    V result = initialValue;
    for (var index = 0; index < length; index++) {
      final current = elementAt(index);
      final previous = index > 0 ? elementAt(index - 1) : null;
      switch ((result, combine(previous, current))) {
        case (final int res, final int comb):
          result = (res + comb) as V;
        case (final double res, final double comb):
          result = (res + comb) as V;
        case (final BigInt res, final BigInt comb):
          result = (res + comb) as V;
        case (final String res, final String comb):
          result = (res + comb) as V;
        case (final List res, final List comb):
          result = (res + comb) as V;
      }
    }
    return result;
  }
}

extension IndexedIterableEx<T extends Object?> on Iterable<(int, T)> {
  V foldValue<V extends Object>(
    V initialValue,
    V Function((int, T)? previous, (int, T) current) combine,
  ) {
    V result = initialValue;
    final it = iterator;
    while (it.moveNext()) {
      final (index, e) = it.current;
      final previous = index > 0 ? elementAt(index - 1) : null;
      switch ((result, combine(previous, it.current))) {
        case (final int res, final int comb):
          result = (res + comb) as V;
        case (final double res, final double comb):
          result = (res + comb) as V;
        case (final BigInt res, final BigInt comb):
          result = (res + comb) as V;
        case (final String res, final String comb):
          result = (res + comb) as V;
        case (final List res, final List comb):
          result = (res + comb) as V;
      }
    }
    return result;
  }
}
