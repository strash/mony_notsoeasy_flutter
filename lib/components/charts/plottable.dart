part of "./chart.dart";

enum EChartTemporalComponent {
  month,
  year,
  weekday,
  date,
}

abstract base class ChartPlottableValue<T extends Object> {
  /// Just a meta information which won't be visualized.
  String get label;

  /// This is a numeric value like a [double] or [int] for quantitative data,
  /// [DateTime] for temporal data, or [String] for categorical data.
  T get value;
  num get numericValue;

  int compareTo(covariant ChartPlottableValue other);

  @override
  int get hashCode;

  @override
  bool operator ==(covariant ChartPlottableValue<T> other);

  num operator +(num other);

  static ChartPlottableValue<num> quantitative(
    String label, {
    required num value,
  }) {
    return _QuantitativeImpl(label, value: value);
  }

  static ChartPlottableValue<DateTime> temporal(
    String label, {
    required DateTime value,
    EChartTemporalComponent component = EChartTemporalComponent.date,
  }) {
    return _TemporalImpl(label, value: value, component: component);
  }

  static ChartPlottableValue<String> categorical(
    String label, {
    required String value,
  }) {
    return _CategoricalImpl(label, value: value);
  }
}

final class _QuantitativeImpl implements ChartPlottableValue<num> {
  @override
  final String label;
  @override
  final num value;
  @override
  num get numericValue => value;

  const _QuantitativeImpl(this.label, {required this.value});

  @override
  int compareTo(ChartPlottableValue<num> other) => value.compareTo(other.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(_QuantitativeImpl other) => hashCode == other.hashCode;

  @override
  num operator +(num other) => numericValue + other;

  @override
  String toString() {
    return "$label - $value";
  }
}

final class _TemporalImpl implements ChartPlottableValue<DateTime> {
  @override
  final String label;
  @override
  final DateTime value;
  @override
  num get numericValue {
    return switch (component) {
      EChartTemporalComponent.month => value.month,
      EChartTemporalComponent.year => value.year,
      EChartTemporalComponent.weekday => value.weekday,
      EChartTemporalComponent.date => value.startOfDay.millisecondsSinceEpoch,
    };
  }

  final EChartTemporalComponent component;

  const _TemporalImpl(
    this.label, {
    required this.value,
    required this.component,
  });

  @override
  int compareTo(ChartPlottableValue<DateTime> other) {
    return switch (component) {
      EChartTemporalComponent.month => value.month.compareTo(other.value.month),
      EChartTemporalComponent.year => value.year.compareTo(other.value.year),
      EChartTemporalComponent.weekday =>
        value.weekday.compareTo(other.value.weekday),
      EChartTemporalComponent.date =>
        value.startOfDay.compareTo(other.value.startOfDay),
    };
  }

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(_TemporalImpl other) => hashCode == other.hashCode;

  @override
  num operator +(num other) => numericValue + other;

  @override
  String toString() {
    return "$label - $value (${component.name})";
  }
}

final class _CategoricalImpl implements ChartPlottableValue<String> {
  @override
  final String label;
  @override
  final String value;
  @override
  num get numericValue => value.length;

  const _CategoricalImpl(this.label, {required this.value});

  @override
  int compareTo(ChartPlottableValue<String> other) {
    return value.compareTo(other.value);
  }

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(_CategoricalImpl other) => hashCode == other.hashCode;

  @override
  num operator +(num other) => numericValue + other;

  @override
  String toString() {
    return "$label - $value";
  }
}
