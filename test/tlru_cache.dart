import 'package:test/test.dart';
import 'package:dcache/dcache.dart';

void main() {
  const expiry = Duration(seconds: 1, milliseconds: 500);
  const interval = Duration(milliseconds: 500);
  const halfInterval = Duration(milliseconds: 250);
  const evictionOrder = ['b', 'a'];

  late TlruCache<int, String> cache;
  final pause = ({Duration? delay}) => Future<void>.delayed(delay ?? interval);
  var evictionCounter = 0;

  setUp(() {
    cache = TlruCache<int, String>(
      storage: TlruStorage(3),
      expiration: expiry,
      onEvict: (key, value) {
        expect(value, equals(evictionOrder[evictionCounter++]));

        print('evicting {$value}');
      },
    )..loader = (k, _) {
        final s = String.fromCharCode('a'.codeUnitAt(0) + k);
        print('loading {$s}');
        return s;
      };
  });

  test('Evicts expired and least recently used entries; in that order',
      () async {
    cache.get(0);
    cache.get(1);
    await pause(delay: halfInterval);

    cache.get(2);
    cache.get(0);
    cache.get(3); // Evict 'b' (least recently used).
    await pause();

    cache.get(2);
    cache.get(3);
    cache.get(0);
    await pause();

    cache.get(3);
    await pause(delay: halfInterval);

    cache.get(4); // Evict 'a' (expired).
  });
}
