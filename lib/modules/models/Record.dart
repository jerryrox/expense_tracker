class Record {
  String itemId;
  List<String> tagIds;
  int quantity;
  double mass;
  double unitPrice;
  DateTime date;

  Record({
    this.itemId = "",
    this.tagIds = const [],
    this.quantity = 1,
    this.mass = 0,
    this.unitPrice = 0,
    this.date,
  });
}
