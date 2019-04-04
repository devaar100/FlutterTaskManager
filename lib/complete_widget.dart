import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './globals.dart' as globals;

class CompleteWidget extends StatefulWidget{

  bool complete;
  int pos;
  Function isComplete;

  CompleteWidget(this.complete, this.pos, this.isComplete);

  @override
  State<CompleteWidget> createState() {
    return _CompleteWidgetState(complete,pos,isComplete);
  }
}

class _CompleteWidgetState extends State<CompleteWidget>{

  bool complete;
  String url;
  Function isComplete;

  _CompleteWidgetState(complete,pos,isComplete){
    this.complete = complete;
    this.url = globals.url+pos.toString()+'/.json';
    this.isComplete = isComplete;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(
                "Completed",
                style: TextStyle(
                  fontSize: 18
                ),
            )
        ),
        Switch(
            value: complete,
            onChanged: (val){
              setState(() {
                complete = val;
                isComplete(complete);
              });
            }
        )
      ],
    );
  }
}