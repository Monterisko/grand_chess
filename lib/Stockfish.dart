import 'dart:js' as js;

class Stockfish {
  late var engine;

  Stockfish() {
    init();
  }

  void init() {
    String script = 'var stockfish = new Worker("stockfish.js");';

    js.context.callMethod('eval', [script]);

    engine = js.context['stockfish'];
    engine.callMethod('postMessage', ['uci']);
    engine.callMethod('addEventListener', [
      'message',
      (js.JsObject event) {
        var data = event['data'];
        print(data);
      }
    ]);
    engine.callMethod('postMessage', ['isready']);
  }

  void sendCommand(String command) {
    engine.callMethod('postMessage', [command]);
  }
}
