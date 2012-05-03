#import ('dart:html');
#import ('dart:json');

class client {
  
  String _endPoint;
  
  client(this._endPoint) {}
  
  void render(List<Map<String, String>> data) {
    StringBuffer sb = new StringBuffer();
    sb.add('<ul>');
    for (final Map<String, String> m in data) {
      sb.add('<li>${m["id"]}:${m["message"]}</li>');
    }
    sb.add('</ul>');
    write(sb.toString());
  }
  
  void run() {
    document.query('#status').innerHTML = 'dart is running';
    reload();
  }
  
  void write(String message) {
    document.query('#dataList').innerHTML = message;
  }
  
  void reload() {
    print('reload()');
    var request = new XMLHttpRequest.getTEMPNAME(
      this._endPoint, (XMLHttpRequest req) {
        print('req');
        render(JSON.parse(req.responseText));
      });
  }
  
}

void main() {
  new client('/dart/api/data.json').run();
}
