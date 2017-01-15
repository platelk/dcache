import 'package:test/test.dart';

import 'package:dcache/dcache.dart';

void main() {
  test("Test cache initialization", () {
    Cache cache = new Cache(storage: new SimpleStorage(size: 20));
    expect(cache, isNotNull);
  });
  //
  test("Test simple insert/get", () {
    Cache c = new Cache(storage: new SimpleStorage(size: 20));

    c.set("key", 42);
    expect(c.get("key"), equals(42));
  });
 test("Test simple loader function", () {
    Cache<int, int> c = new Cache<int, int>(storage: new SimpleStorage(size: 20))
              ..loader = (int k) => k*10;
    expect(c.get(4), equals(40));
    expect(c.get(5), equals(50));
  });
}