import 'package:expense_tracker/modules/api/getCategories/GetCategoriesApi.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/ui/components/primitives/BottomContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/CategoryCell.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/TextRoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordCategoryPage extends StatefulWidget {
  RecordCategoryPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordCategoryPageState();
}

class _RecordCategoryPageState extends State<RecordCategoryPage> with UtilMixin, SnackbarMixin {
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  String searchValue = "";

  UserState get userState => Provider.of<UserState>(context, listen: false);

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      loadCategories();
    });
  }

  /// Loads the list of categories recorded by this user.
  Future loadCategories() async {
    try {
      final categories = await GetCategoriesApi(userState.user.value.uid).request();
      setState(() => this.categories = categories);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Starts a new category creation process for the user.
  Future createCategory() async {
    try {
      // TODO: Show the category creation popup while passing the searchValue as the initial name.
      // TODO: If returned category is non-null, add that to the categories list.

      filterCategories();
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Filteres the categories list so it reflects the search value.
  void filterCategories() {
    List<Category> newCategories = [];
    if (searchValue.isEmpty) {
      newCategories.addAll(categories);
    } else {
      for (Category category in categories) {
        if (category.name.toLowerCase().contains(searchValue)) {
          filteredCategories.add(category);
        }
      }
    }
    setState(() => filteredCategories = newCategories);
  }

  /// Navigates to the tags selection page.
  void navigateToTags(Category category) {
    // TODO:
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a category"),
      ),
      body: FilledBox(
        child: ContentPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                "Search for the category you want, or create a new one.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: _onSearchValueChange,
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => CategoryCell(
                    category: categories[index],
                    onClick: () => _onCategoryButton(categories[index]),
                  ),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: categories.length,
                ),
              ),
              BottomContentPadding(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: TextRoundedButton(
                    "Create a new category",
                    isFullWidth: true,
                    onClick: _onCreateButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Event called when the search text field value was changed.
  void _onSearchValueChange(String value) {
    searchValue = value;
  }

  /// Event called when the category create button was pressed.
  void _onCreateButton() {
    createCategory();
  }

  /// Event called when one of the category cells was pressed.
  void _onCategoryButton(Category category) {
    navigateToTags(category);
  }
}
