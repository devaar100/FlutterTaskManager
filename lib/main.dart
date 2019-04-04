import 'package:flutter/material.dart';

import './task_list.dart';
import './task_detail.dart';
import './globals.dart' as globals;

void main() => runApp(MaterialApp(home: MyWidget()));

class MyWidget extends StatefulWidget {

  @override
  State<MyWidget> createState() {
    return _MyWidgetState();
  }
}

class _MyWidgetState extends State<MyWidget> {

  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text( 'Task Manager' );
  final TaskList taskList = TaskList();

  _MyWidgetState(){
    _filter.addListener((){
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          taskList.filterList(_searchText);
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          taskList.filterList(_searchText);
        });
    }});
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
          _searchIcon = Icon(Icons.close);
          _appBarTitle = TextField(
          controller: _filter,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...'
          ),
        );
      } else {
        _searchText = "";
        taskList.filterList(_searchText);
        _searchIcon = Icon(Icons.search);
        _appBarTitle = Text('Tasks');
        _filter.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _appBarTitle,
          backgroundColor: globals.mainColor,
          actions: <Widget>[
            IconButton(
                icon: _searchIcon,
                onPressed: () {
                  _searchPressed();
                }
            )
          ],
        ),
        body: taskList,
        floatingActionButton: MyFAB(taskList)
    );
  }
}

class MyFAB extends StatelessWidget{

  TaskList taskList;

  MyFAB(this.taskList);

  @override
  Widget build(BuildContext context) {

    final task = {
      'name':'',
      'desc':'',
      'complete':false,
      'complete_date':'00/00/00000',
    };

    return FloatingActionButton(
      // When the user presses the button, show an alert dialog with the
      // text the user has typed into our text field.
      onPressed: () {
        taskList.addNew(task,true);
      },
      backgroundColor: globals.mainColor,
      tooltip: 'Show me the value!',
      child: Icon(
          Icons.add
      ),
    );
  }
}