import 'package:expense_tracker/modules/api/create_tag/create_tag_api.dart';
import 'package:expense_tracker/modules/api/get_tags/get_tags_api.dart';
import 'package:expense_tracker/modules/dependencies/app_navigation.dart';
import 'package:expense_tracker/modules/dependencies/user_state.dart';
import 'package:expense_tracker/modules/mixins/loader_mixin.dart';
import 'package:expense_tracker/modules/mixins/snackbar_mixin.dart';
import 'package:expense_tracker/modules/mixins/util_mixin.dart';
import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/modules/models/tag.dart';
import 'package:expense_tracker/ui/components/primitives/bottom_content_padding.dart';
import 'package:expense_tracker/ui/components/primitives/button_with_constraint.dart';
import 'package:expense_tracker/ui/components/primitives/content_padding.dart';
import 'package:expense_tracker/ui/components/primitives/filled_box.dart';
import 'package:expense_tracker/ui/components/primitives/page_top_margin.dart';
import 'package:expense_tracker/ui/components/primitives/tag_cell.dart';
import 'package:expense_tracker/ui/components/primitives/text_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordTagPage extends StatefulWidget {
  final Category category;

  RecordTagPage({
    Key key,
    this.category,
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

  /// Returns the current category in context.
  Category get category => widget.category;

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
      final api = GetTagsApi(userState.uid).forCategory(category.id);
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

      final api = CreateTagApi(userState.uid, category.id, name);
      final tag = await api.request();
      setState(() => tags.add(tag));
      applyFilter();
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Navigates to the price recording page
  void navigateToPrice() {
    appNavigation.toRecordPricePage(context, category, [
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
                PageTopMargin(),
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
                  child: ButtonWidthConstraint(
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
    navigateToPrice();
  }
}
