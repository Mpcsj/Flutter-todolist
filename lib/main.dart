import 'package:flutter/material.dart';
import 'package:todo_list/models/ItemList.dart';
import 'package:todo_list/utils/file-utils.dart';
import 'package:todo_list/components/item-list.dart';
import 'package:todo_list/components/snackbar.dart';
const TAG = 'main';
void main() {
  runApp(MaterialApp(
    title:'Todo list app',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<ItemList> _todoList = [];
  ItemList _lastRemoved;
  int _idxLastRemoved;
  TextEditingController todoController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  addItem(){
    setState(() {
      _todoList.add(ItemList(todoController.text, false));
      _formKey = GlobalKey<FormState>();
      todoController.text = '';
      saveData(_todoList);
    });
  }

  Future<Null>_refreshContentList()async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _todoList.sort((a,b){
        if(a.done && !b.done) return 1;
        else if(!a.done && b.done)return -1;
        else return 0;
      });
    });
    return null;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData().then((value){
      if(value!=null){
        print('Lista recebida do arquivo: ${value}');
        setState(() {
          _todoList = value;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo list app'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child:TextFormField(
                      controller: todoController,
                      decoration: InputDecoration(
                          labelText: 'Nova tarefa',
                          labelStyle: TextStyle(color:Colors.blueAccent)
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Favor informar a tarefa a ser adicionada';
                        }
                        return null;
                      },
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    child: Text('Add'),
                    textColor: Colors.white,
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        addItem();
                      }
                    } ,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshContentList,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: _todoList.length,
                itemBuilder: (context,index){
                  ItemList curr = _todoList[index];
                  return getItemList(curr,(newValue){
                    setState(() {
                      curr.done = newValue;
                      saveData(_todoList);
                    });
                  },(){
                    // onDismiss
                    _lastRemoved = curr;
                    _idxLastRemoved = index;
                    setState(() {
                      _todoList.removeAt(index);
                      saveData(_todoList);
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                          getSimpleActionedSnackbar(
                              'Tarefa \"${curr.title}\" removida!',
                              'Desfazer',
                              Duration(seconds: 2),
                                  (){
                                setState(() {
                                  _todoList.insert(_idxLastRemoved, _lastRemoved);
                                  saveData(_todoList);
                                });
                              }
                          )
                      );
                      // Scaffold.of(context).showSnackBar(snackbar)
                    });
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
