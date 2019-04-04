import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './globals.dart' as globals;
import './complete_widget.dart';

class TaskDetail extends StatefulWidget{

  var task;

  TaskDetail(this.task);

  @override
  State<TaskDetail> createState() {
    return _TaskDetailState(task);
  }
}

class _TaskDetailState extends State<TaskDetail>{

  var _task;
  var _context;
  var _changed = false;
  TextEditingController _nameController ,_descController;
  TextField _name, _desc;
  bool inEdit = false;

  void isComplete(val){
    _task['complete'] = val;
  }

  void hasChanged(){
    _changed = true;
  }

  void updateDBTask() async{
    hasChanged();
    print(_task);
    await http.put(
      globals.url+_task['pos'].toString()+'/.json',
      body: json.encode(_task)
    ).then((val){
      showDialog(
        context: _context,
        builder: (context){
          return AlertDialog(
            content: Text("Data upload complete"),
          );
        }
      );
    });
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: _context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2000),
        lastDate: new DateTime(2100)
    );
    if(picked != null)
      setState((){
        _task['complete_date'] = picked.day.toString()+'/'+picked.month.toString()+'/'+picked.year.toString();
      });
  }

  Future<bool> onPop(){
    Navigator.pop(
        _context,
        _changed==true
    );
    return Future<bool>.value(false);
  }

  _TaskDetailState(task){
    this._task = task;
    _nameController = TextEditingController(text: task['name']);
    _descController = TextEditingController(text: task['desc']);
    _name = TextField(
      controller: _nameController,
      style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
      ),
    );
    _desc = TextField(
      controller: _descController,
      maxLines: 5,
      style: TextStyle(
        fontSize: 17,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return WillPopScope(
        onWillPop: onPop,
        child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Task Manager",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: globals.mainColor,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _name,
              SizedBox(height: 10),
              _desc,
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(_task['complete_date']),
                  ),
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){
                        _selectDate();
                      }
                  )
                ],
              ),
              CompleteWidget(_task['complete'],_task['pos'],isComplete),
              Expanded(
                child: SizedBox(),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  padding: EdgeInsets.all(10),
                  child: Text(
                        "Save Changes",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                        ),
                  ),
                  color: globals.mainColor,
                  onPressed: (){
                    _task['name'] = _nameController.text;
                    _task['desc'] = _descController.text;
                    updateDBTask();
                  },
                )
              )
            ],
          ),
        )
      ),
    );
  }
}
