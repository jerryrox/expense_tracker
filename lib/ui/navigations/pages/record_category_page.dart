import 'package:expense_tracker/modules/api/get_categories/get_categories_api.dart';
import 'package:expense_tracker/modules/dependencies/app_navigation.dart';
import 'package:expense_tracker/modules/dependencies/user_state.dart';
import 'package:expense_tracker/modules/mixins/dialog_mixin.dart';
import 'package:expense_tracker/modules/mixins/loader_mixin.dart';
import 'package:expense_tracker/modules/mixins/snackbar_mixin.dart';
import 'package:expense_tracker/modules/mixins/util_mixin.dart';
import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/ui/components/primitives/category_cell.dart';
import 'package:expense_tracker/ui/components/primitives/content_padding.dart';
import 'package:expense_tracker/ui/components/primitives/filled_box.dart';
import 'package:expense_tracker/ui/components/primitives/lined_divider.dart';
import 'package:expense_tracker/ui/components/primitives/page_top_margin.dart';
import 'package:expense_tracker/ui/components/primitives/text_rounded_button.dart';
import 'package:expense_tracker/ui/navigations/popups/category_create_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordCategoryPage extends StatefulWidget {
  RecordCategoryPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordCategoryPageState();
}

class _RecordCategoryPageState extends State<RecordCategoryPage> with UtilMixin, SnackbarMixin, DialogMixin, LoaderMixin {
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
    final loader = showLoader(context);

    try {
      final categories = await GetCategoriesApi(userState.uid).request();
      setState(() => this.categories = categories);
      filterCategories();
    } catch (e) {
      showSnackbar(context, e.toString());
      Navigator.of(context).pop();
    }

    loader.remove();
  }

  /// Starts a new category creation process for the user.
  Future createCategory() async {
    try {
      final category = await showDialogDefault<Category>(
        context,
        CategoryCreatePopup(initialName: searchValue.trim()),
      );
      if (category != null) {
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
      filtered.addAll(categories.where((element) => element.name.toLowerCase().contains(searchValue.toLowerCase())));
    }
    _sortCategories(filtered);

    setState(() => filteredCategories = filtered);
  }

  /// Navigates to the price entering page
  void navigateToPrice(Category category) {
    appNavigation.toRecordPricePage(context, category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a category"),
      ),
      body: SafeArea(
        child: FilledBox(
          child: ContentPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PageTopMargin(),
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
                      category: filteredCategories[index],
                      onClick: () => _onCategoryButton(filteredCategories[index]),
                    ),
                    separatorBuilder: (context, index) => LinedDivider(),
                    itemCount: filteredCategories.length,
                  ),
                ),
              ],
            ),
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
    navigateToPrice(category);
  }
}
