#library ('MongoWebServer');
#import ('dart:io');
#import ('dart:json');
#import ('mongo.dart');

class SimpleHttpServer {
  
  final _HOST = '127.0.0.1';
  final _PORT = 8080;
  final _MSG_404 = '404 Not found.';
  final _MSG_405 = '405 Method not allowed.';
  final _LOG_REQUESTS = true;
  
  final String _basePath;
  final HttpServer _server;
  final MongoDb _db;
  
  SimpleHttpServer(this._basePath)
    : _server = new HttpServer(), _db =new MongoDb()
  {
    _server.defaultRequestHandler = root_handler;
  }
  
  void run() {
    _server.listen(_HOST, _PORT);
    print('SimpleHttpServer start ${_HOST}:${_PORT}');
  }
  
  void root_handler(HttpRequest req, HttpResponse res) {
    if (_LOG_REQUESTS) {
      print('Request root_handler: ${req.method} ${req.uri} ${req.path}');
    }
    
    switch (req.method.toString()) {
    case 'GET':
      doGet(req, res);
      break;
    case 'POST':
      doPost(req, res);
      break;
    default:
      do405(req, res);
    }
  }
  
  void doGet(HttpRequest req, HttpResponse res) {
    var path = req.path == '/' ? '/index.html' : req.path;

    var params = req.queryParameters;
    if (path == '/index.html' && params.containsKey('message')) {
      _db.dataInsert(params['message']);
    }

    if (path == '/dart/api/data.json') {
      print('_db.dataSelect');
      _db.dataSelect((List<Map> entries) {
        List<Map> msgs = new List<Map>();
        entries.forEach((e) {
          msgs.add({ 'id': e['id'], 'message': e['message'] });
        });

        res.headers.set(HttpHeaders.CONTENT_TYPE, 'application/json');
        res.outputStream.writeString(JSON.stringify(msgs));
        res.outputStream.close();
      });
    } else {
      var file = new File('${_basePath}${path}');
      file.exists((found) {
        if (found) {
          file.openInputStream().pipe(res.outputStream);
        } else {
          do404(req, res);
        }
      });
    }
  }
  
  void doPost(HttpRequest req, HttpResponse res) {
    do405(req, res);
  }
  
  void do404(HttpRequest req, HttpResponse res) {
    res.headers.set(HttpHeaders.CONTENT_TYPE, 'text/plain;charset=UTF-8');
    res.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
    res.outputStream.writeString(_MSG_405);
    res.outputStream.close();
  }
  
  void do405(HttpRequest req, HttpResponse res) {
    res.headers.set(HttpHeaders.CONTENT_TYPE, 'text/plain;charset=UTF-8');
    res.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
    res.outputStream.writeString(_MSG_405);
    res.outputStream.close();
  }
  
}
