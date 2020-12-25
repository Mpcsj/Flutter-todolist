import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/ItemList.dart';
Widget getItemList(ItemList curr,Function onChange,Function onDismiss){
  return Dismissible(
    onDismissed: (direction){
      onDismiss();
    },
    key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
    background: Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment(-0.9,0),
        child: Icon(Icons.delete,color: Colors.white),
      ),
    ),
    direction: DismissDirection.startToEnd,
    child: CheckboxListTile(
      title: Text(curr.title),
      value:curr.done,
      secondary: CircleAvatar(
        child: Icon(curr.done?Icons.check:Icons.error),
        backgroundColor: curr.done?Colors.blueAccent:Colors.red,
        foregroundColor: Colors.white,
      ),
      onChanged: (newValue){
        onChange(newValue);
      },
    ),
  );
}

/**
 *
 * */