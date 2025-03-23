import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:web/web.dart' as html;

@JS('getOutput')
external String getOutput();

@JS('isCheckmate')
external bool isCheckmate();

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

  void checkCheckmate() {
    sendCommand('go mate 0');
  }

  bool isChecmate() {
    return isCheckmate();
  }

  String getBestMove() {
    return getOutput();
  }
}
