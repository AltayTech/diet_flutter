import 'dart:async';

class LiveEvent {
  LiveEvent({bool sync = false}) : _streamController = StreamController(sync: sync);

  LiveEvent.broadCast({bool sync = false})
      : _streamController = StreamController.broadcast(sync: sync);

  final StreamController _streamController;

  Stream<void> get stream => _streamController.stream;

  void fireMessage(String message) => _streamController.sink.add(message);

  void fire(dynamic data) {
    if (!_streamController.isClosed) _streamController.sink.add(data);
  }

  void close() => _streamController.close();
}
