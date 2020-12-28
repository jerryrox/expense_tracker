import 'package:expense_tracker/modules/api/getCategories/GetCategoriesApi.dart';
import 'package:expense_tracker/modules/dependencies/AppNavigation.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:expense_tracker/modules/mixins/DialogMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/NewRecordFormData.dart';
import 'package:expense_tracker/ui/components/primitives/CategoryCell.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/LinedDivider.dart';
import 'package:expense_tracker/ui/components/primitives/TextRoundedButton.dart';
import 'package:expense_tracker/ui/navigations/popups/CategoryCreatePopup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordCategoryPage extends StatefulWidget {
  RecordCategoryPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordCategoryPageState();
}

class _RecordCategoryPageState extends State<RecordCategoryPage> with UtilMixin, SnackbarMixin, DialogMixin {
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  String searchValue = "";

  UserState get userState => Provider.of<UserState>(context, listen: false);
  AppNavigation get appNavigation => Provider.of<AppNavigation>(context, listen: false);

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
      filterCategories();
    } catch (e) {
      showSnackbar(context, e.toString());
      Navigator.of(context).pop();
    }
  }

  /// Starts a new category creation process for the user.
  Future createCategory() async {
    try {
      final category = await showDialogDefault<Category>(
        context,
        CategoryCreatePopup(initialName: searchValue.trim()),
      );
      if(category != null) {
        setState(() => categories.add(category));
        filterCategories();
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Sets the current search value.
  void setSearchValue(String value) {
    setState(() => this.searchValue = value);
    filterCategories();
  }

  /// Filteres the categories list so it reflects the search value.
  void filterCategories() {
    List<Category> filtered = [];
    if (searchValue.isEmpty) {
      filtered.addAll(categories);
    } else {
      filtered.addAll(
        categories.where((element) => element.name.toLowerCase().contains(searchValue.toLowerCase()))
      );
    }
    _sortCategories(filtered);

    setState(() => filteredCategories = filtered);
  }

  /// Navigates to the tags selection page.
  void navigateToTags(Category category) {
    appNavigation.toRecordTagPage(context, NewRecordFormData(
      category: category,
    ));
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
              TextRoundedButton(
                "Create a new category",
                isFullWidth: true,
                onClick: _onCreateButton,
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => CategoryCell(
                    category: categories[index],
                    onClick: () => _onCategoryButton(categories[index]),
                  ),
                  separatorBuilder: (context, index) => LinedDivider(),
                  itemCount: categories.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sorts the specified categories list.
  void _sortCategories(List<Category> categories) {
    categories.sort((x, y) => x.name.toLowerCase().compareTo(y.name.toLowerCase()));
  }

  /// Event called when the search text field value was changed.
  void _onSearchValueChange(String value) {
    setSearchValue(value);
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
