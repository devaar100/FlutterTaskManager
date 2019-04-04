import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './task_detail.dart';
import './globals.dart' as globals;

class TaskList extends StatefulWidget{

  final _TaskListState _taskListState = _TaskListState();
  Function addNew;

  void filterList(search){
    _taskListState.searchListUpdate(search);
  }

  @override
  State<TaskList> createState() {
    addNew  = _taskListState.taskDetailWork;
    return _taskListState;
  }
}

class _TaskListState extends State<TaskList>{

  var _taskList;
  var _currentList;

  @override
  void initState(){
    getTaskList();
    super.initState();
  }

  void searchListUpdate(search){
    if(search==""){
      _currentList = List.from(_taskList);
    } else{
      search = search.toLowerCase();
      _currentList.clear();
      for(int i=0; i<_taskList.length;i++){
        var task = _taskList[i];
        if(task['name'].toLowerCase().contains(search))
          _currentList.add(task);
      }
    }
    setState(() {
    });
  }

  void getTaskList() async {
    var data = await getTaskJson();
    for(int i=0;i<data.length;i++){
      data[i]['pos'] = i;
    }
    setState(() {
      _taskList = List.from(data);
      _currentList = List.from(data);
    });
  }

  void updateCurrentTaskJson(pos) async {
    http.Response resp = await http.get(globals.url+pos.toString()+'/.json');
    final updated_task = json.decode(resp.body);
    _taskList[pos]['complete'] = _currentList[pos]['complete'] = updated_task['complete'];
    setState(() {
    });
  }

  void taskDetailWork(task,isNew) async {
      if(isNew==true) {
        task['pos'] = _taskList.length;
      }
      bool changed = await Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return TaskDetail(task);
          }
      )
      );
      if(changed==true) {
        if(isNew){
          _taskList.add(Map.from(task));
          _currentList.add(Map.from(task));
          setState(() {
          });
        } else {
          updateCurrentTaskJson(task['pos']);
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentList == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Fetching your tasks...",
              style: TextStyle(
                  fontSize: 20
              ),
            )
          ],
        ),
      );
    }

    if (_currentList.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "No tasks to show",
              style: TextStyle(
                  fontSize: 20
              ),
            )
          ],
        ),
      );
    }

    return ListView.separated(
        itemCount: _currentList.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 4,
            color: Colors.grey,
          );
        },
        itemBuilder: (context, i) {
          var task = _currentList[i];
          return GestureDetector(
              child: _TaskBlock(task),
              onTap: () {
                taskDetailWork(task, false);
              }
          );
        }
    );
  }
}

class _TaskBlock extends StatelessWidget{

  final _task;

  _TaskBlock(this._task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            child: Center(
              child: Text(
                _task['name'][0],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
            ),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: globals.mainColor,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _task['name'],
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                  Text(
                    _task['complete']==true?"Completed":"Finish by : "+_task['complete_date'],
                    style: TextStyle(
                        fontSize: 15,
                        color: _task['complete']==true?Colors.green:Colors.red,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    _task['desc'],
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<List> getTaskJson() async {
  var url = globals.url+'.json';
  http.Response response = await http.get(url);
  return json.decode(response.body);
}