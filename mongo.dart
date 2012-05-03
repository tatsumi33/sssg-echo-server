#library ('mongo.dart');
#import ('mongo-dart/lib/mongo.dart');

class MongoDb {
  
  int _currentId = 0;
  
  DbCollection _collection(onOpened(DbCollection col)) {
    final Db db = new Db('sssg');
    db.open().then((bool result) {
      Future f = onOpened(db.collection('echo-server'));
      if (f != null) {
        f.then((e) { db.close(); });
      } else {
        db.close();
      }
    });
  }
  
  MongoDb() {
    _collection((DbCollection col) {
      col.remove();
    });
  }
  
  void dataInsert(String m) {
    _collection((DbCollection col) {
      print('dataInsert($m)');
      return col.insert({'id': '${_currentId++}', 'message': m});
    });
  }
  
  void dataSelect(onSelected(List<Map> entries)) {
    _collection((DbCollection col) {
      Future<List<Map>> f = col.find({}).toList();
      f.then(onSelected);
      f.handleException((e) {
          print('Error. - ${e.message}');
      });
      return f;
    });
  }
  
}
