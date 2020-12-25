import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/models/ItemList.dart';
const TAG = 'utils/file-utils';
Future<File>getFile()async{
  final directory = await getApplicationDocumentsDirectory();
  return File("${directory.path}/data.json");
}

saveData(List list)async{
  // print('$TAG::saveData::list:$list');
  String data = json.encode(list);
  // print('$TAG::dados serializados:$data');
  final file = await getFile();
  return file.writeAsString(data);
}

Future<List<ItemList>> readData()async{
  try{
    final file = await getFile();
    String data = await file.readAsString();
    print("Obtido ao ler do arquivo: ${data}");

    List<dynamic> aux = json.decode(data);
    // print('Lista feita parse ${aux}::tam da lista::${aux.length}');
    List<ItemList>res=[];
    aux.forEach((e){
      // print('$TAG::fazendo o parsing do item: $e');
      ItemList curr =ItemList.fromJson(e);
      // print('$TAG::elemento convertido::${curr}');
      res.add(curr);
    });
    // print('$TAG::lista a retornar:$res');
    //
    return res;
  }catch(e){
    print('$TAG::crash ao fazer parsing: $e');
    return [];
  }
}
