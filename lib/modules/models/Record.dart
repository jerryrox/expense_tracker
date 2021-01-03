class Record {
  String id;
  String categoryId;
  List<String> tagIds;
  double price;
  DateTime date;

  Record({
    this.id = "",
    this.categoryId = "",
    this.tagIds = const [],
    this.price,
    this.date,
  });
}
