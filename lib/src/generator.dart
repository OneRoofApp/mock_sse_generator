import 'dart:async';

import 'event.dart';

typedef ServerSideEventBuilder = ServerSideEvent Function();

class Generator {
  final Duration? period;
  final ServerSideEventBuilder builder;

  final StreamController<ServerSideEvent> _streamController =
      StreamController<ServerSideEvent>.broadcast();
  Timer? _timer;

  Generator({
    this.period,
    required this.builder,
  });

  Stream<ServerSideEvent> get serverStream => _streamController.stream;

  void start() {
    _timer = Timer.periodic(period ?? kPeriod, (timer) {
      _streamController.add(builder());
    });
  }

  void stop() {
    _timer?.cancel();
  }

   void destroy() {
    _streamController.close();
  }
}

const Duration kPeriod = Duration(seconds: 2);
