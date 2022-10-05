import 'package:flutter_test/flutter_test.dart';
import 'package:mock_sse_generator/mock_sse_generator.dart';

class TestServerSideEvent implements ServerSideEvent {
  final String data;

  TestServerSideEvent({
    required this.data,
  });
}

void main() {
  test('Should emit 1 event in the default 2 secs', () async {
    final generator = Generator(
      builder: () => TestServerSideEvent(
        data: 'data',
      ),
    );
    final eventList = generator.serverStream.toList();

    generator.start();
    await Future.delayed(const Duration(seconds: 2));
    generator.stop();

    generator.destroy();

    final events = await eventList;
    expect(events.length, 1);
  });

  test('Should emit 1 event in the set period', () async {
    final generator = Generator(
      period: const Duration(seconds: 1),
      builder: () => TestServerSideEvent(
        data: 'data',
      ),
    );
    final eventList = generator.serverStream.toList();

    generator.start();
    await Future.delayed(const Duration(seconds: 1));
    generator.stop();

    generator.destroy();

    final events = await eventList;
    expect(events.length, 1);
  });

  test('Should emit 2 events in 2x the set period', () async {
    final generator = Generator(
      period: const Duration(seconds: 1),
      builder: () => TestServerSideEvent(
        data: 'data',
      ),
    );
    final eventList = generator.serverStream.toList();

    generator.start();
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
    generator.stop();

    generator.destroy();

    final events = await eventList;
    expect(events.length, 2);
  });

  test('Should emit 2 different events in 2x the set period', () async {
    int counter = 0;
    final generator = Generator(
      period: const Duration(seconds: 1),
      builder: () => TestServerSideEvent(
        data: 'data-${++counter}',
      ),
    );
    final eventList = generator.serverStream.toList();

    generator.start();
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
    generator.stop();

    generator.destroy();

    final events = await eventList;
    expect(events.length, 2);

     TestServerSideEvent event = events.first as TestServerSideEvent;
    expect(event.data, 'data-1');

    event = events.last as TestServerSideEvent;
    expect(event.data, 'data-2');
  });
}
