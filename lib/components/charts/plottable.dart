part of "./chart.dart";

enum EChartTemporalComponent {
  day,
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

  int compareTo(covariant ChartPlottableValue other);

  @override
  int get hashCode;

  @override
  bool operator ==(covariant ChartPlottableValue<T> other);

  num operator +(covariant ChartPlottableValue<T> other);

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

  const _QuantitativeImpl(this.label, {required this.value});

  @override
  int compareTo(ChartPlottableValue<num> other) => value.compareTo(other.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(_QuantitativeImpl other) => hashCode == hashCode;

  @override
  num operator +(_QuantitativeImpl other) => value + other.value;

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
  final EChartTemporalComponent component;

  const _TemporalImpl(
    this.label, {
    required this.value,
    required this.component,
  });

  @override
  int compareTo(ChartPlottableValue<DateTime> other) {
    return switch (component) {
      EChartTemporalComponent.day => value.day.compareTo(other.value.day),
      EChartTemporalComponent.month => value.month.compareTo(other.value.month),
      EChartTemporalComponent.year => value.year.compareTo(other.value.year),
      EChartTemporalComponent.weekday =>
        value.weekday.compareTo(other.value.weekday),
      EChartTemporalComponent.date => value.compareTo(other.value),
    };
  }

  @override
  int get hashCode {
    return switch (component) {
      EChartTemporalComponent.day => value.day.hashCode,
      EChartTemporalComponent.month => value.month.hashCode,
      EChartTemporalComponent.year => value.year.hashCode,
      EChartTemporalComponent.weekday => value.weekday.hashCode,
      EChartTemporalComponent.date => value.hashCode,
    };
  }

  @override
  bool operator ==(_TemporalImpl other) {
    return hashCode == hashCode;
  }

  @override
  int operator +(_TemporalImpl other) => 1 + 1;

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

  const _CategoricalImpl(this.label, {required this.value});

  @override
  int compareTo(ChartPlottableValue<String> other) {
    return value.compareTo(other.value);
  }

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(_CategoricalImpl other) => hashCode == hashCode;

  @override
  int operator +(_CategoricalImpl other) => 1 + 1;

  @override
  String toString() {
    return "$label - $value";
  }
}
