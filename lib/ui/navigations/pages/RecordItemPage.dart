import 'package:expense_tracker/modules/models/NewRecordFormData.dart';
import 'package:flutter/material.dart';

class RecordItemPage extends StatefulWidget {
  final NewRecordFormData formData;
  
  RecordItemPage({Key key, this.formData,}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _RecordItemPageState();
}

class _RecordItemPageState extends State<RecordItemPage> {

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}