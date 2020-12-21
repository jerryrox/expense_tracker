class Record {
  String itemId;
  List<String> tagIds;
  int quantity;
  double mass;
  double unitPrice;
  DateTime date;

  /// Returns whether the price is based on the quantity.
  bool get isQuantityBased => quantity > 0;

  /// Returns whether the price is based on the mass.
  bool get isMassBased => mass > 0;

  /// Returns the final price of the record.
  double get price => (isQuantityBased ? quantity.toDouble() : mass) * unitPrice;

  Record({
    this.itemId = "",
    this.tagIds = const [],
    this.quantity = 0,
    this.mass = 0,
    this.unitPrice = 0,
    this.date,
  });
}
