import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:web/web.dart' as html;

@JS('getOutput')
external String getOutput();

class Stockfish {
  Stockfish() {
    init();
  }

  void init() {
    sendCommand('uci');
    sendCommand('isready');
  }

  void sendCommand(String command) {
    html.window.callMethod('sendCommand'.toJS, command.toJS);
  }

  String getBestMove() {
    return getOutput();
  }
}
