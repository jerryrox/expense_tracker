class Record {
  String id;
  String itemId;
  List<String> tagIds;
  double price;
  DateTime date;

  Record({
    this.id = "",
    this.itemId = "",
    this.tagIds = const [],
    this.price,
    this.date,
  });
}
