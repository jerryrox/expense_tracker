import 'package:expense_tracker/modules/api/createTag/CreateTagApi.dart';
import 'package:expense_tracker/modules/api/getTags/GetTagsApi.dart';
import 'package:expense_tracker/modules/dependencies/AppNavigation.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:expense_tracker/modules/mixins/LoaderMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/Tag.dart';
import 'package:expense_tracker/ui/components/primitives/BottomContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/TagCell.dart';
import 'package:expense_tracker/ui/components/primitives/TextRoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordTagPage extends StatefulWidget {
  final Category category;
  final Item item;

  RecordTagPage({
    Key key,
    this.category,
    this.item,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordTagPageState();
}

class _RecordTagPageState extends State<RecordTagPage> with UtilMixin, SnackbarMixin, LoaderMixin {
  List<Tag> tags = [];
  List<Tag> filteredTags = [];
  List<Tag> selectedTags = [];

  String searchValue = "";

  UserState get userState => Provider.of<UserState>(context, listen: false);
  AppNavigation get appNavigation => Provider.of<AppNavigation>(context, listen: false);

  /// Returns the uid of the current user.
  String get uid => userState.user.value.uid;

  /// Returns the current category in context.
  Category get category => widget.category;

  /// Returns the current item in context.
  Item get item => widget.item;

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      loadTags();
    });
  }

  /// Loads the list of tags included for the current category.
  Future loadTags() async {
    final loader = showLoader(context);

    try {
      final api = GetTagsApi(uid).forCategory(category.id);
      final tags = await api.request();
      setState(() => this.tags = tags);
      applyFilter();
    } catch (e) {
      showSnackbar(context, e.toString());
      Navigator.of(context).pop();
    }

    loader.remove();
  }

  /// Creates a new tag with current search value as name.
  Future createTag() async {
    final loader = showLoader(context);

    try {
      final name = searchValue.trim();
      if (name.isEmpty) {
        throw "Please enter a valid name.";
      }

      final api = CreateTagApi(uid, category.id, name);
      final tag = await api.request();
      setState(() => tags.add(tag));
      applyFilter();
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Navigates to the item selection page.
  void navigateToItems() {
    appNavigation.toRecordPricePage(context, item, [
      ...selectedTags
    ]);
  }

  /// Sets the current search input value.
  void setSearchValue(String value) {
    setState(() => this.searchValue = value);
    applyFilter();
  }

  /// Toggles selection state for the specified tag.
  void selectTag(Tag tag) {
    if (_isSelected(tag)) {
      setState(() => selectedTags.remove(tag));
    } else {
      setState(() => selectedTags.add(tag));
    }
  }

  /// Applies search filter on the tags list.
  void applyFilter() {
    List<Tag> filtered = [];
    if (searchValue.isEmpty) {
      filtered.addAll(tags);
    } else {
      filtered.addAll(tags.where((element) => element.name.toLowerCase().contains(searchValue.toLowerCase())));
      // Ensure the selected tags are included as well.
      for (final selected in selectedTags) {
        if (!filtered.contains(selected)) {
          filtered.add(selected);
        }
      }
    }
    _sortTags(filtered);

    setState(() => filteredTags = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select tags"),
      ),
      body: SafeArea(
        child: FilledBox(
          child: ContentPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  "Search for the tag you want, or create a new one.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: _onSearchValueChanged,
                ),
                SizedBox(height: 10),
                TextRoundedButton(
                  searchValue.isEmpty ? "Create tag" : "Create tag ($searchValue)",
                  onClick: _onCreateTagButton,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    children: filteredTags.map((e) {
                      return TagCell(
                        tag: e,
                        isSelected: _isSelected(e),
                        onClick: () => _onTagButton(e),
                      );
                    }).toList(),
                  ),
                ),
                BottomContentPadding(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: TextRoundedButton(
                      selectedTags.isEmpty ? "Skip" : "Next",
                      isFullWidth: true,
                      onClick: _onNextButton,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns whether the specified tag has been selected.
  bool _isSelected(Tag tag) {
    return selectedTags.contains(tag);
  }

  /// Sorts the specified tags list.
  void _sortTags(List<Tag> tags) {
    tags.sort((x, y) {
      final selectedX = _isSelected(x);
      final selectedY = _isSelected(y);
      if (selectedX && !selectedY) {
        return -1;
      }
      if (!selectedX && selectedY) {
        return 1;
      }
      return x.name.toLowerCase().compareTo(y.name.toLowerCase());
    });
  }

  /// Event called when the tag create button was clicked.
  void _onCreateTagButton() {
    createTag();
  }

  /// Event called when the search input value was changed.
  void _onSearchValueChanged(String value) {
    setSearchValue(value);
  }

  /// Event called when one of the tag buttons have been clicked.
  void _onTagButton(Tag tag) {
    selectTag(tag);
  }

  /// Event called when the "next" button was clicked
  void _onNextButton() {
    navigateToItems();
  }
}
