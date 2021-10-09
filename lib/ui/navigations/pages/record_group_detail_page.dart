import 'package:expense_tracker/modules/api/delete_record/delete_record_api.dart';
import 'package:expense_tracker/modules/api/get_tags/get_tags_api.dart';
import 'package:expense_tracker/modules/dependencies/user_state.dart';
import 'package:expense_tracker/modules/mixins/dialog_mixin.dart';
import 'package:expense_tracker/modules/mixins/loader_mixin.dart';
import 'package:expense_tracker/modules/mixins/snackbar_mixin.dart';
import 'package:expense_tracker/modules/mixins/util_mixin.dart';
import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/modules/models/record.dart';
import 'package:expense_tracker/modules/models/record_group.dart';
import 'package:expense_tracker/modules/models/tag.dart';
import 'package:expense_tracker/ui/components/primitives/content_padding.dart';
import 'package:expense_tracker/ui/components/primitives/filled_box.dart';
import 'package:expense_tracker/ui/components/primitives/lined_divider.dart';
import 'package:expense_tracker/ui/components/primitives/page_top_margin.dart';
import 'package:expense_tracker/ui/components/primitives/record_cell.dart';
import 'package:expense_tracker/ui/components/primitives/total_spent_display.dart';
import 'package:expense_tracker/ui/navigations/popups/selection_dialog_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordGroupDetailPage extends StatefulWidget {
  final RecordGroup recordGroup;

  RecordGroupDetailPage({
    Key key,
    this.recordGroup,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecordGroupDetailPageState();
}

class _RecordGroupDetailPageState extends State<RecordGroupDetailPage> with UtilMixin, SnackbarMixin, LoaderMixin, DialogMixin {
  List<Record> records = [];
  List<Tag> tags = [];

  UserState get userState => Provider.of<UserState>(context, listen: false);

  /// Returns the category in context.
  Category get category => widget.recordGroup.category;

  /// Returns the total amount spent.
  double get totalAmount => widget.recordGroup.totalAmount;

  @override
  void initState() {
    super.initState();

    afterFrameRender(() async {
      await loadTags();
      cacheRecords();
    });
  }

  /// Loads the list of tags from the server.
  Future loadTags() async {
    final loader = showLoader(context);

    try {
      final api = GetTagsApi(userState.uid).forCategory(category.id);
      final tags = await api.request();
      setState(() => this.tags = tags);
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Starts listening to user's selection on what to do with the selected record.
  Future queryRecordAction(Record record) async {
    final deleteAction = "Delete";
    final selection = await showDialogDefault<String>(context, SelectionDialogPopup(
      message: "Choose an action for this record",
      selections: [deleteAction, "Cancel"],
    ));

    if(selection == deleteAction) {
      deleteRecord(record);
    }
  }

  /// Deletes the specified record.
  Future deleteRecord(Record record) async {
    final loader = showLoader(context);

    try {
      final api = DeleteRecordApi(userState.uid, record.id);
      await api.request();
      _removeRecord(record);
    }
    catch(e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Caches the list of records from the group into state.
  void cacheRecords() {
    setState(() => this.records = [...widget.recordGroup.records]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details - ${category.name}"),
      ),
      body: SafeArea(
        child: FilledBox(
          child: ContentPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PageTopMargin(),
                TotalSpentDisplay(amount: totalAmount),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final record = records[index];
                      final tags = _getTagsByIds(record.tagIds);
                      return RecordCell(
                        category: category,
                        record: record,
                        tags: tags,
                        onClick: () => _onRecordButton(record),
                      );
                    },
                    separatorBuilder: (context, index) => LinedDivider(),
                    itemCount: records.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the list of tags matching the specified ids.
  List<Tag> _getTagsByIds(List<String> ids) {
    return tags.where((element) => ids.contains(element.id)).toList();
  }

  /// Removes the specified record from the record group and the records list.
  void _removeRecord(Record record) {
    setState(() {
      widget.recordGroup.removeRecord(record);
      records.remove(record);
    });
  }

  /// Event called when the record button was clicked.
  void _onRecordButton(Record record) {
    queryRecordAction(record);
  }
}
