import 'package:test/test.dart';
import 'package:dcache/dcache.dart';

void main() {
  late TlruCache cache;
  final expiry = Duration(seconds: 1, milliseconds: 500);
  final interval = Duration(milliseconds: 500);
  late int intervalCounter;
  final pause = () async {
    await Future<void>.delayed(interval);
    intervalCounter++;
  };

  setUp(() {
    intervalCounter = 0;
    cache = TlruCache<int, String>(
      storage: TlruStorage(2),
      expiry: expiry,
      onEvict: (key, value) {
        expect(value, equals(intervalCounter > 0 ? 'a' : 'b'));

        print('$intervalCounter | evicting {$value}');
      },
    )..loader = (k, _) {
        final s = String.fromCharCode('a'.codeUnitAt(0) + k);
        print('$intervalCounter | loading {$s}');
        return s;
      };
  });

  test('Evicts the expired entries first', () async {
    cache.get(0);
    await pause();
    cache.get(1);
    await pause();
    cache.get(0);
    await pause();

    // Evict 'a' (most recently used) because it is exipred.
    cache.get(2);
  });

  test('Evicts the least recently used entry, if no expired entry is present',
      () {
    cache.get(0);
    cache.get(1);
    cache.get(0);

    // Evict 'b' (least recently used).
    cache.get(2);
  });
}
