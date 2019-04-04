import 'package:flutter/material.dart';

class EditText extends StatefulWidget{

  @override
  State<EditText> createState() {
    return _EditTextState();
  }
}

class _EditTextState extends State<EditText>{

  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
          controller: _textController,
    );
  }
}