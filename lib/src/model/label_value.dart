class LabelValue {
  LabelValue({
    this.label,
    this.value,
    this.optional = const {},
  });

  final String label;
  final String value;
  final Map optional;
}
