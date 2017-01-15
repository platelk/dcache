import 'package:test/test.dart';

import 'package:dcache/dcache.dart';

void main() {
  test("Test cache initialization", () {
    Cache cache = new SimpleCache(20);
    expect(cache, isNotNull);
  });
  //
  test("Test simple insert/get", () {
    Cache c = new SimpleCache(20);

    c.set("key", 42);
    expect(c.get("key"), equals(42));
  });
}