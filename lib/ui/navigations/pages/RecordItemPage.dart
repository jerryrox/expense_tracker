import 'package:expense_tracker/modules/api/createItem/CreateItemApi.dart';
import 'package:expense_tracker/modules/api/getItems/GetItemsApi.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/NewRecordFormData.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/ItemCell.dart';
import 'package:expense_tracker/ui/components/primitives/LinedDivider.dart';
import 'package:expense_tracker/ui/components/primitives/TextRoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordItemPage extends StatefulWidget {
  final NewRecordFormData formData;

  RecordItemPage({
    Key key,
    this.formData,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordItemPageState();
}

class _RecordItemPageState extends State<RecordItemPage> with UtilMixin, SnackbarMixin {
  List<Item> items = [];
  List<Item> filteredItems = [];
  String searchValue = "";

  UserState get userState => Provider.of<UserState>(context, listen: false);

  /// Returns the category currently in context.
  Category get category => widget.formData.category;

  /// Returns the uid of the current user.
  String get uid => userState.user.value.uid;

  /// Returns whether the search value is currently non-empty.
  bool get hasSearchValue => searchValue.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      loadItems();
    });
  }

  /// Loads the list of items in the current category.
  Future loadItems() async {
    try {
      final api = GetItemsApi(uid).forCategory(category.id);
      final items = await api.request();
      setState(() => this.items = items);
      applyFilter();
    } catch (e) {
      showSnackbar(context, e.toString());
      Navigator.of(context).pop();
    }
  }

  /// Creates a new item using the search value provided.
  Future createItem() async {
    try {
      final name = searchValue.trim();
      if (name.isEmpty) {
        throw "Please enter a valid name.";
      }

      final api = CreateItemApi(uid, category.id, name);
      final item = await api.request();
      items.add(item);
      applyFilter();
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Applies filter to displayed items list using search value.
  void applyFilter() {
    List<Item> filtered = [];
    if (hasSearchValue) {
      final search = searchValue.trim().toLowerCase();
      filtered.addAll(items.where((element) => element.name.toLowerCase().contains(search)));
    } else {
      filtered.addAll(items);
    }
    _sortItemsList(filtered);

    setState(() => filteredItems = filtered);
  }

  /// Sets the current search value.
  void setSearchValue(String value) {
    this.searchValue = value;
    applyFilter();
  }

  /// Navigates to the price recording page with the specified item.
  void navigateToPricePage(Item item) {
    // TODO:
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select an item"),
      ),
      body: FilledBox(
        child: ContentPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text("Search for an item, or create a new one."),
              SizedBox(height: 10),
              TextField(
                onChanged: _onSearchValueChanged,
              ),
              SizedBox(height: 10),
              TextRoundedButton(
                !hasSearchValue ? "Create new item" : "Create new item (${searchValue.trim()})",
                onClick: _onCreateButton,
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ItemCell(
                      item: item,
                      onClick: () => _onItemButton(item),
                    );
                  },
                  separatorBuilder: (context, index) => LinedDivider(),
                  itemCount: filteredItems.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sorts the specified items list.
  void _sortItemsList(List<Item> items) {
    items.sort((x, y) => x.name.toLowerCase().compareTo(y.name.toLowerCase()));
  }

  /// Event called when the search bar value was changed.
  void _onSearchValueChanged(String value) {
    setSearchValue(value);
  }

  /// Event called when the item cell was clicked.
  void _onItemButton(Item item) {
    navigateToPricePage(item);
  }

  /// Event called when the item create button was clicked.
  void _onCreateButton() {
    createItem();
  }
}
