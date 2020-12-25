class ItemList{
  String title;
  bool done;

  ItemList(String title,bool done){
    this.title = title;
    this.done = done;
  }

  ItemList.fromJson(Map<String,dynamic>json):
      title = json['title'],
      done = json['done'];

  Map<String,dynamic>toJson()=>{
    'title':title,
    'done':done
  };
}