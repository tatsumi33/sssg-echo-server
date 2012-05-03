#import ('dart:io');
#import ('httpserver.dart');

void main() {
  File script = new File(new Options().script);
  script.directory((Directory d) {
    new SimpleHttpServer(d.path).run();
  });
}
